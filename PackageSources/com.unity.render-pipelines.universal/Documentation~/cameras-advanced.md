# Camera rendering order and overdraw

## Camera culling and rendering order
If your Universal Render Pipeline (URP) Scene contains multiple Cameras, Unity performs their culling and rendering operations in a predictable order.

Once per frame, Unity performs the following operations:

1. Unity gets the list of all active [Base Cameras](camera-types-and-render-mode.md#base-camera) in the Scene.
2. Unity organises the active Base Cameras into the following groups:
    * Cameras that render their view to Render Textures
    * Cameras that render their view to the screen
3. Unity sorts the Base Cameras that render to Render Textures into priority order, so that Cameras with a lower numerical priority are drawn before Base Cameras with a higher numerical priority.
4. For each Base Camera that renders to a Render Texture, Unity performs the following steps:
    1. Cull the Base Camera
    2. Render the Base Camera to the Render Texture
    3. For each [Overlay Camera](camera-types-and-render-mode.md#overlay-camera) that is part of the Base Camera's [Camera Stack](camera-stacking.md), in the order defined in the Camera Stack:
        1. Cull the Overlay Camera
        2. Render the Overlay Camera to the Render Texture
5. Unity sorts the Base Cameras that render to Render Textures into priority order, so that Cameras with a lower numerical priority are drawn before Base Cameras with a higher numerical priority.
6. For each Base Camera that renders to a Render Texture, Unity performs the following steps:
    1. Cull the Base Camera
    2. Render the Base Camera to the Render Texture
    3. For each [Overlay Camera](camera-types-and-render-mode.md#overlay-camera) that is part of the Base Camera's [Camera Stack](camera-stacking.md), in the order defined in the Camera Stack:
        1. Cull the Overlay Camera
        2. Render the Overlay Camera to the Render Texture

Unity can render an Overlay Camera’s view multiple times during a frame - either because the Overlay Camera appears in more than one Camera Stack, or because the Overlay Camera appears in the same Camera Stack more than once. When this happens, Unity does not reuse any element of the culling or rendering operation. The operations are repeated in full, in the order detailed above.

## Overdraw

Unity does not perform any optimizations within URP to prevent overdraw.

When multiple Cameras in a Camera Stack render to the same render target, Unity draws each pixel in the render target for each Camera in the Camera Stack. Additionally, if more than one Base Camera or Camera Stack renders to the same area of the same render target, Unity draws any pixels in the overlapping area again, as many times as required by each Base Camera or Camera Stack.

With this in mind, you must manage your Cameras to prevent excessive overdraw, which can result in excessive CPU and GPU resource usage. You can use Unity's [Frame Debugger](https://docs.unity3d.com/Manual/FrameDebugger.html), or platform-specific frame capture and debugging tools, to understand where excessive overdraw occurs in your Scene. You can then optimize your use of Cameras accordingly.
