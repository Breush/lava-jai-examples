Basic :: #import "Basic";
Unicode :: #import "Unicode";

Crater :: #import "Crater";

main :: () {
    window := Crater.create_window(.{width=1600, height=900}, "Crater | Events");

    while true {
        event := Crater.window_poll_event(window);

        if event.kind != .None {
            Basic.print("% -> ", event.kind);

            if event.kind == .WindowClosed {
                Basic.print("Closing window.\n");
                break;
            }
            else if event.kind == .KeyPressed &&
                    event.key.which == Crater.Key.Escape {
                Basic.print("% -- Closing window.\n", event.key);
                break;
            }

            if event.kind == .TextEntered {
                Basic.print("%\n", event.text);
            } else if event.kind == .KeyPressed || event.kind == .KeyReleased {
                Basic.print("%\n", event.key);
            } else if event.kind == .MousePointerMoved {
                Basic.print("%\n", event.mousePointer);
            } else if event.kind == .MouseWheelScrolled {
                Basic.print("%\n", event.mouseWheel);
            } else if event.kind == .WindowSizeChanged {
                Basic.print("%\n", event.windowSize);
            } else if event.kind == .MouseButtonPressed || event.kind == .MouseButtonReleased {
                Basic.print("%\n", event.mouseButton);
            } else {
                Basic.print("\n");
            }
        }
    }

    Crater.destroy_window(window);
}
