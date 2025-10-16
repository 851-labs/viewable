import SwiftUI

/// Provides the common navigation title and toolbar buttons for the Metal gradient showcase.
struct AnyDistanceMetalGradientInfoModifier: ViewModifier {
  @Environment(\.openURL) private var openURL
  
  private let articleURL = URL(string: "https://www.spottedinprod.com/blog/any-distance-goes-open-source")!
  private let sourceCodeURL = URL(string: "https://github.com/851-labs/viewable/blob/main/viewable/AnyDistance/AnyDistanceMetalGradientView.swift")!

  func body(content: Content) -> some View {
    content
      .navigationTitle("Metal Gradient")
      .navigationSubtitle("AnyDistance")
      .toolbar {
        ToolbarItemGroup {
          Button {
            openURL(articleURL)
          } label: {
            Label("View article", systemImage: "book.pages")
          }
          Button {
            openURL(sourceCodeURL)
          } label: {
            Label("View source code", systemImage: "curlybraces")
          }
        }
      }
  }
}

extension View {
  /// Applies the Gradient Animation navigation title and toolbar buttons.
  func anyDistanceMetalGradientInfo() -> some View {
    modifier(AnyDistanceMetalGradientInfoModifier())
  }
}

#if canImport(UIKit)

import MetalKit

// MARK: - Renderer

final class AnyDistanceMetalGradientRenderer: NSObject, MTKViewDelegate {
  @MainActor
  private let device: MTLDevice
  private var commandQueue: MTLCommandQueue!
  private var pipeline: MTLRenderPipelineState!
  private var vertexBuffer: MTLBuffer!
  private var viewSize: vector_float2 = .zero
  private var startTime = CFAbsoluteTimeGetCurrent()

  // uniforms buffers
  private var timeBuffer: MTLBuffer!
  private var viewSizeBuffer: MTLBuffer!
  private var pageBuffer: MTLBuffer!
  private var page: Int

  @MainActor
  init(mtkView: MTKView, page: Int = 0) {
    self.device = mtkView.device!
    self.page = page
    super.init()
    buildResources(view: mtkView)
  }

  @MainActor
  private func buildResources(view: MTKView) {
    commandQueue = device.makeCommandQueue()

    // load shader
    guard let library = device.makeDefaultLibrary() else { fatalError("Unable to create Metal library") }
    let vertex = library.makeFunction(name: "gradient_animation_vertex")!
    let fragment = library.makeFunction(name: "gradient_animation_fragment")!

    let pipelineDescriptor = MTLRenderPipelineDescriptor()
    pipelineDescriptor.vertexFunction = vertex
    pipelineDescriptor.fragmentFunction = fragment
    pipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat

    do {
      pipeline = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
    } catch {
      fatalError("Pipeline error: \(error)")
    }

    updateVertices(for: view.drawableSize)

    timeBuffer = device.makeBuffer(length: MemoryLayout<Float>.stride, options: [])
    viewSizeBuffer = device.makeBuffer(length: MemoryLayout<vector_float2>.stride, options: [])
    pageBuffer = device.makeBuffer(length: MemoryLayout<Int32>.stride, options: [])
    setPage(page)
  }

  @MainActor
  private func updateVertices(for size: CGSize) {
    let w = Float(size.width)
    let h = Float(size.height)
    let verts: [SIMD2<Float>] = [
      SIMD2(0, 0),
      SIMD2(w, 0),
      SIMD2(0, h),
      SIMD2(w, h)
    ]
    vertexBuffer = device.makeBuffer(bytes: verts, length: MemoryLayout<SIMD2<Float>>.stride * verts.count, options: [])
  }

  @MainActor
  func setPage(_ newPage: Int) {
    page = newPage
    var p = Int32(page)
    memcpy(pageBuffer.contents(), &p, MemoryLayout<Int32>.stride)
  }

  func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
    viewSize = vector_float2(Float(size.width), Float(size.height))
    updateVertices(for: size)
  }

  func draw(in view: MTKView) {
    guard let drawable = view.currentDrawable,
          let descriptor = view.currentRenderPassDescriptor else { return }

    // update time uniform
    var time = Float(CFAbsoluteTimeGetCurrent() - startTime)
    memcpy(timeBuffer.contents(), &time, MemoryLayout<Float>.stride)
    memcpy(viewSizeBuffer.contents(), &viewSize, MemoryLayout<vector_float2>.stride)

    let commandBuffer = commandQueue.makeCommandBuffer()!
    let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
    encoder.setRenderPipelineState(pipeline)

    encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    encoder.setVertexBuffer(timeBuffer, offset: 0, index: 1)
    encoder.setVertexBuffer(viewSizeBuffer, offset: 0, index: 2)
    encoder.setVertexBuffer(pageBuffer, offset: 0, index: 3)

    encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
    encoder.endEncoding()

    commandBuffer.present(drawable)
    commandBuffer.commit()
  }
}

// MARK: - SwiftUI View

struct AnyDistanceMetalGradientView: UIViewRepresentable {
  let page: Int
  func makeUIView(context: Context) -> MTKView {
    let mtkView = MTKView(frame: .zero, device: MTLCreateSystemDefaultDevice())
    mtkView.isPaused = false
    mtkView.enableSetNeedsDisplay = false
    mtkView.preferredFramesPerSecond = 60
    mtkView.framebufferOnly = false
    mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    let renderer = AnyDistanceMetalGradientRenderer(mtkView: mtkView, page: page)
    mtkView.delegate = renderer
    context.coordinator.renderer = renderer
    return mtkView
  }

  func updateUIView(_ uiView: MTKView, context: Context) {
    if let renderer = context.coordinator.renderer as? AnyDistanceMetalGradientRenderer {
      renderer.setPage(page)
    }
  }

  func makeCoordinator() -> Coordinator {
    Coordinator()
  }

  class Coordinator {
    var renderer: AnyObject?
  }
}

// Showcase wrapper
struct AnyDistanceMetalGradientShowcaseView: View {
  private let gradientTabs: [(title: String, symbol: String)] = [
    ("Sunset", "sun.horizon.fill"),
    ("Ocean", "water.waves"),
    ("Lagoon", "leaf.fill"),
    ("Neon", "sparkles")
  ]

  var body: some View {
    TabView {
      ForEach(Array(gradientTabs.enumerated()), id: \.offset) { index, tab in
        Tab(tab.title, systemImage: tab.symbol) {
          AnyDistanceMetalGradientView(page: index)
            .ignoresSafeArea()
            .tag(index)
        }
      }
    }
    .anyDistanceMetalGradientInfo()
  }
}

#else

struct AnyDistanceMetalGradientShowcaseView: View {
  var body: some View {
    ContentUnavailableView("Gradient animation is unavailable on this platform", systemImage: "pc")
      .anyDistanceMetalGradientInfo()
  }
}

#endif

#Preview("AnyDistance Gradient") {
  NavigationStack { AnyDistanceMetalGradientShowcaseView() }
}
