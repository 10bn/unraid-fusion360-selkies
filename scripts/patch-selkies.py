#!/usr/bin/env python3
from pathlib import Path
import re

input_path = Path('/opt/gst-web/input.js')
index_path = Path('/opt/gst-web/index.html')

text = input_path.read_text(encoding='utf-8')
old = """        if ('ontouchstart' in window) {
            this.listeners_context.push(addListener(window, 'touchstart', this._touch, this));
            this.listeners_context.push(addListener(this.element, 'touchend', this._touch, this));
            this.listeners_context.push(addListener(this.element, 'touchmove', this._touch, this));

            console.log("Enabling mouse pointer display for touch devices.");
            this.send("p,1");
            console.log("remote pointer visibility to: True");
        } else {
            this.listeners_context.push(addListener(this.element, 'mousemove', this._mouseButtonMovement, this));
            this.listeners_context.push(addListener(this.element, 'mousedown', this._mouseButtonMovement, this));
            this.listeners_context.push(addListener(this.element, 'mouseup', this._mouseButtonMovement, this));
        }
"""
new = """        if ('ontouchstart' in window) {
            this.listeners_context.push(addListener(window, 'touchstart', this._touch, this));
            this.listeners_context.push(addListener(this.element, 'touchend', this._touch, this));
            this.listeners_context.push(addListener(this.element, 'touchmove', this._touch, this));

            console.log("Enabling mouse pointer display for touch devices.");
            this.send("p,1");
            console.log("remote pointer visibility to: True");
        }

        // iPadOS always exposes touch support, even with Magic Keyboard or a mouse.
        // Keep pointer listeners enabled alongside the touch listeners.
        this.listeners_context.push(addListener(this.element, 'mousemove', this._mouseButtonMovement, this));
        this.listeners_context.push(addListener(this.element, 'mousedown', this._mouseButtonMovement, this));
        this.listeners_context.push(addListener(this.element, 'mouseup', this._mouseButtonMovement, this));
"""
if old not in text:
    raise SystemExit('Expected Selkies input block was not found; base image may have changed.')
input_path.write_text(text.replace(old, new, 1), encoding='utf-8')

index = index_path.read_text(encoding='utf-8')
patched, count = re.subn(r'input\.js\?ts=[^\"]+', 'input.js?ts=ipad-pointer-v1', index, count=1)
if count != 1:
    raise SystemExit('Could not update input.js cache key in index.html.')
index_path.write_text(patched, encoding='utf-8')
