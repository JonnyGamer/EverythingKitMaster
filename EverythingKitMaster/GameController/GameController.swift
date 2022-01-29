//
//  GameController.swift
//  EverythingKitMaster
//
//  Created by Jonathan Pappas on 1/28/22.
//

import GameController

extension ViewController {

    func setupGameController() {
        if #available(iOS 14.0, OSX 10.16, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleMouseDidConnect),
                                                   name: NSNotification.Name.GCMouseDidBecomeCurrent, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.handleMouseDidDisconnect),
                                                   name: NSNotification.Name.GCMouseDidStopBeingCurrent, object: nil)
            if let mouse = GCMouse.mice().first {
                registerMouse(mouse)
            }
        }

        NotificationCenter.default.addObserver(self, selector: #selector(self.handleKeyboardDidConnect),
                                               name: NSNotification.Name.GCKeyboardDidConnect, object: nil)

        NotificationCenter.default.addObserver(
                self, selector: #selector(self.handleControllerDidConnect),
                name: NSNotification.Name.GCControllerDidBecomeCurrent, object: nil)

        NotificationCenter.default.addObserver(
            self, selector: #selector(self.handleControllerDidDisconnect),
            name: NSNotification.Name.GCControllerDidStopBeingCurrent, object: nil)
        guard let controller = GCController.controllers().first else {
            return
        }
        registerGameController(controller)
    }

    func unregisterGameController() {
        gamePadLeft = nil
        gamePadRight = nil
        gamePadCurrent = nil
    }

    @objc
    func handleMouseDidConnect(_ notification: Notification) {
        if #available(iOS 14.0, OSX 10.16, *) {
            guard let mouse = notification.object as? GCMouse else {
                return
            }

            unregisterMouse()
            registerMouse(mouse)

        }
    }

    @objc
    func handleMouseDidDisconnect(_ notification: Notification) {
        unregisterMouse()
    }


    func unregisterMouse() {
        delta = CGPoint.zero
    }

    func registerMouse(_ mouseDevice: GCMouse) {
        if #available(iOS 14.0, OSX 10.16, *) {
            guard let mouseInput = mouseDevice.mouseInput else {
                return
            }

            weak var weakController = self
            mouseInput.mouseMovedHandler = {(_ mouse: GCMouseInput, _ deltaX: Float, _ deltaY: Float) -> Void in
                guard let strongController = weakController else {
                    return
                }
                strongController.delta = CGPoint(x: CGFloat(deltaX), y: CGFloat(deltaY))
            }

            mouseInput.leftButton.valueChangedHandler = {
                (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
                guard let _ = weakController else { return }
                //// print("left button pressed")
            }
            mouseInput.rightButton?.valueChangedHandler = {
                (_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
                guard let _ = weakController else { return }
                //// print("right button pressed")
            }

            mouseInput.mouseMovedHandler = { (mouse: GCMouseInput, x: Float, y: Float) -> Void in
                guard let _ = weakController else { return }
                //// print("Mouse Moved", x, y)
            }

            mouseInput.scroll.valueChangedHandler = {
                (_ cursor: GCControllerDirectionPad, _ scrollX: Float, _ scrollY: Float) -> Void in
                guard let _ = weakController else { return }
                //scene.mouseScrolled(CGVector.init(dx: CGFloat(scrollX)*2, dy: 2*CGFloat(scrollY)))
                //// print("scrolling")
            }
        }
    }

    @objc
    func handleControllerDidConnect(_ notification: Notification) {
        guard let gameController = notification.object as? GCController else {
            return
        }
        unregisterGameController()
        registerGameController(gameController)
    }

    @objc
    func handleControllerDidDisconnect(_ notification: Notification) {
        unregisterGameController()

        guard let gameController = notification.object as? GCController else {
            return
        }
    }

    func registerGameController(_ gameController: GCController) {

        var buttonA: GCControllerButtonInput?
        var buttonB: GCControllerButtonInput?
        var buttonX: GCControllerButtonInput?
        var buttonY: GCControllerButtonInput?
        var buttonMenu: GCControllerButtonInput?
        var buttonHome: GCControllerButtonInput?
        var buttonOptions: GCControllerButtonInput?

        var rightTrigger: GCControllerButtonInput?
        var leftTrigger: GCControllerButtonInput?
        var updPad: GCControllerButtonInput?
        var downdPad: GCControllerButtonInput?
        var leftdPad: GCControllerButtonInput?
        var rightdPad: GCControllerButtonInput?
        var rightThumbStickX: GCControllerAxisInput?
        var rightThumbStickY: GCControllerAxisInput?
        var rightThumbStickButton: GCControllerButtonInput?
        var leftThumbStickX: GCControllerAxisInput?
        var leftThumbStickY: GCControllerAxisInput?
        var leftThumbStickButton: GCControllerButtonInput?

        var leftShoulder: GCControllerButtonInput?
        var rightShoulder: GCControllerButtonInput?

        weak var weakController = self

        if let gamepad = gameController.extendedGamepad {

            // A and B Buttons
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonB
            buttonX = gamepad.buttonX
            buttonY = gamepad.buttonY
            buttonMenu = gamepad.buttonMenu
            buttonHome = gamepad.buttonHome
            buttonOptions = gamepad.buttonOptions

            // Triggers and Shoulders
            rightTrigger = gamepad.rightTrigger
            leftTrigger = gamepad.leftTrigger
            leftShoulder = gamepad.leftShoulder
            rightShoulder = gamepad.rightShoulder

            // DPad
            dPad = gamepad.dpad
            updPad = gamepad.dpad.up
            downdPad = gamepad.dpad.down
            leftdPad = gamepad.dpad.left
            rightdPad = gamepad.dpad.right

            // Thumbsticks
            self.gamePadLeft = gamepad.leftThumbstick
            self.gamePadRight = gamepad.rightThumbstick
            rightThumbStickX = gamepad.rightThumbstick.xAxis
            rightThumbStickY = gamepad.rightThumbstick.yAxis
            rightThumbStickButton = gamepad.rightThumbstickButton
            leftThumbStickX = gamepad.leftThumbstick.xAxis
            leftThumbStickY = gamepad.leftThumbstick.yAxis
            leftThumbStickButton = gamepad.leftThumbstickButton

        } else if let gamepad = gameController.microGamepad {
            self.gamePadLeft = gamepad.dpad
            buttonA = gamepad.buttonA
            buttonB = gamepad.buttonX
        }


        // ABXY Buttons
        buttonA?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .a, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .a)
            }
            //// print("A", pressed)
        }
        buttonB?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .back, hardness: CGFloat(value))
            }
            //// print("B", pressed)
        }
        buttonX?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .back, hardness: CGFloat(value))
            }
            //// print("X", pressed)
        }
        buttonY?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .back, hardness: CGFloat(value))
            }
            //// print("Y", pressed)
        }

        // Home, Options, Menu Buttons
        buttonHome?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("Home", pressed)
        }
        buttonOptions?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("Options", pressed)
        }
        buttonMenu?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("Menu", pressed)
        }


        // Triggers and Shoulders
        rightTrigger?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("RIGHT TRIGGER", pressed, value)
        }
        leftTrigger?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("LEFT TRIGGER", pressed, value)
        }
        rightShoulder?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("RIGHT SHOULDER", pressed, value)
        }
        leftShoulder?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("LEFT SHOULDER", pressed, value)
        }


        updPad?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .upArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .upArrow)
            }
            //// print("up", pressed)
        }
        downdPad?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .downArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .downArrow)
            }
            //// print("down", pressed)
        }
        leftdPad?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .leftArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .leftArrow)
            }
            //// print("left", pressed)
        }
        rightdPad?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .rightArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .rightArrow)
            }
            //// print("right", pressed)
        }
        rightThumbStickButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("right thumb stick button", pressed)
        }
        leftThumbStickButton?.valueChangedHandler = {(_ button: GCControllerButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            //// print("left thumb stick button", pressed)
        }
        rightThumbStickX?.valueChangedHandler = {(axis: GCControllerAxisInput, value: Float) -> Void in
            guard let _ = weakController else { return }
            // print("Foo")
//            if scene.cursorX == 0, value != 0 {
//                scene.cursorX = CGFloat(value)
//                scene.cursorBegan()
//            } else {
//                scene.cursorX = CGFloat(value)
//                if value == 0 {
//                    scene.cursorEnded()
//                }
//            }
            //// print("right thumb stick x", axis, value)
        }
        rightThumbStickY?.valueChangedHandler = {(axis: GCControllerAxisInput, value: Float) -> Void in
            guard let _ = weakController else { return }

//            if scene.cursorY == 0, value != 0 {
//                scene.cursorBegan()
//                scene.cursorY = CGFloat(value)
//            } else {
//                scene.cursorY = CGFloat(value)
//                if value == 0 {
//                    scene.cursorEnded()
//                }
//            }
            //// print("right thumb stick y", axis, value)
        }
        leftThumbStickX?.valueChangedHandler = {(axis: GCControllerAxisInput, value: Float) -> Void in
            guard let _ = weakController else { return }
            //// print("left thumb stick x", axis, value)
            if value > 0.2 {
                root.keyReleased(key: .leftArrow)
                root.keyPressed(key: .rightArrow, hardness: CGFloat(value))
                //// print("FULL RIGHT")
            } else if value < -0.2 {
                root.keyReleased(key: .rightArrow)
                root.keyPressed(key: .leftArrow, hardness: CGFloat(-value))
                //// print("FULL LEFT")
            } else {
                root.keyReleased(key: .leftArrow)
                root.keyReleased(key: .rightArrow)
            }
        }
        leftThumbStickY?.valueChangedHandler = {(axis: GCControllerAxisInput, value: Float) -> Void in
            guard let _ = weakController else { return }
            if value > 0.2 {
                //scene.keyReleased(key: .downArrow)
                root.keyPressed(key: .upArrow, hardness: CGFloat(value))
                //// print("FULL RIGHT")
            } else if value < -0.2 {
                //scene.keyReleased(key: .upArrow)
                root.keyPressed(key: .downArrow, hardness: CGFloat(-value))
                //// print("FULL LEFT")
            } else {
                root.keyReleased(key: .upArrow)
                root.keyReleased(key: .downArrow)
            }
        }


    }

    // Connects Keyboard Instead
    @objc
    func handleKeyboardDidConnect(_ notification: Notification) {
        guard let keyboard = notification.object as? GCKeyboard else { return }
        weak var weakController = self
        
        keyboard.keyboardInput?.button(forKeyCode: .keyD)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .d, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .d)
            }
            // print("jumped")
        }
        keyboard.keyboardInput?.button(forKeyCode: .keyS)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .s, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .s)
            }
            // print("jumped")
        }
        keyboard.keyboardInput?.button(forKeyCode: .keyA)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .a, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .a)
            }
            // print("jumped")
        }
        keyboard.keyboardInput?.button(forKeyCode: .spacebar)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .a, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .a)
            }
            // print("jumped")
        }
        keyboard.keyboardInput?.button(forKeyCode: .returnOrEnter)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .a, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .a)
            }
            // print("jumped")
        }

        keyboard.keyboardInput?.button(forKeyCode: .leftArrow)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .leftArrow, hardness: CGFloat(value))
            }else {
                root.keyReleased(key: .leftArrow)
            }
            // print("Left")
        }

        keyboard.keyboardInput?.button(forKeyCode: .rightArrow)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .rightArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .rightArrow)
            }
            // print("Right")
        }

        keyboard.keyboardInput?.button(forKeyCode: .upArrow)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .upArrow, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .upArrow)
            }
            // print("Up")
        }

        keyboard.keyboardInput?.button(forKeyCode: .downArrow)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .downArrow, hardness: CGFloat(value))
            }else {
                root.keyReleased(key: .downArrow)
            }
            // print("Down", pressed)
        }

        keyboard.keyboardInput?.button(forKeyCode: .deleteOrBackspace)?.valueChangedHandler = {
            (_ button: GCDeviceButtonInput, _ value: Float, _ pressed: Bool) -> Void in
            guard let _ = weakController else { return }
            if pressed {
                root.keyPressed(key: .back, hardness: CGFloat(value))
            } else {
                root.keyReleased(key: .back)
            }
            // print("Backspace", pressed)
        }

    }


}
