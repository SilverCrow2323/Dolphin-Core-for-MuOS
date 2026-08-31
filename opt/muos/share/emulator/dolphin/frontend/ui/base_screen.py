#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
BASE SCREEN - Abstract base class for all screens
"""

class Screen:
    """Base class for every screen in the application"""
    
    def __init__(self, app, gui):
        self.app = app          # Reference to the main App controller
        self.gui = gui          # Reference to the SDL2 wrapper
        self.logger = None      # Will be set by subclass
        self.running = True     # False when exiting this screen
        self.fonts = {}         # Font cache (optional)
    
    def enter(self):
        """Called when the screen becomes active"""
        pass
    
    def exit(self):
        """Called when the screen is deactivated"""
        pass
    
    def handle_event(self, event):
        """Handle an SDL event (if needed)"""
        pass
    
    def update(self, delta):
        """Update logic (delta in seconds)"""
        pass
    
    def render(self):
        """Draw the screen"""
        raise NotImplementedError
    
    def on_key_down(self, key):
        """Handle key press (convenience method)"""
        pass
    
    def on_key_up(self, key):
        """Handle key release"""
        pass