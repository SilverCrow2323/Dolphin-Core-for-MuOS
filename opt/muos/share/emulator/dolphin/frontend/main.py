#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
DOLPHIN RT:CORE 'FRONTENDONE' - Entry Point
Advanced frontend for GameCube and Wii emulation on muOS
"""

import sys
import os
import signal
import time

# ============================================================================
# DETERMINE PATHS (ALL RELATIVE TO FRONTEND)
# ============================================================================

FRONTEND_ROOT = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, FRONTEND_ROOT)

# ============================================================================
# INITIALIZE LOGGING FIRST
# ============================================================================

from core.logger import FrontendLogger, get_logger

log_dir = os.environ.get("DOLPHIN_FRONTEND_LOG_DIR")
log_level = os.environ.get("DOLPHIN_FRONTEND_LOG_LEVEL", "INFO")

if not log_dir:
    log_dir = os.path.join(FRONTEND_ROOT, "data", "logs", "frontend")

FrontendLogger.initialize(log_dir, log_level)
FrontendLogger.log_startup()

from core.sdl2_gui import SDL2GUI
from core.boot_verifier import BootVerifier
from ui.boot_animation import BootAnimation
from ui.main_menu import MainMenu
from ui.game_library import GameLibrary
from ui.game_detail import GameDetail
from ui.workshop import Workshop
from ui.settings_docs import SettingsDocs

# ============================================================================
# SIGNAL HANDLING
# ============================================================================

def signal_handler(sig, frame):
    """Handle SIGINT and SIGTERM for clean shutdown"""
    logger = get_logger("main")
    logger.info("Received shutdown signal. Cleaning up...")
    FrontendLogger.log_shutdown()
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)
signal.signal(signal.SIGTERM, signal_handler)

# ============================================================================
# APP CONTROLLER
# ============================================================================

class App:
    """Main controller managing the screen stack"""
    
    def __init__(self, gui):
        self.gui = gui
        self.logger = get_logger("app")
        self.screen_stack = []
        self.running = True
    
    def push_screen(self, screen):
        """Push a screen onto the stack"""
        if self.screen_stack:
            self.screen_stack[-1].exit()
        self.screen_stack.append(screen)
        screen.enter()
        self.logger.info(f"Pushed screen: {screen.__class__.__name__}")
    
    def pop_screen(self):
        """Pop the current screen and return to previous"""
        if self.screen_stack:
            current = self.screen_stack.pop()
            current.exit()
            self.logger.info(f"Popped screen: {current.__class__.__name__}")
        if self.screen_stack:
            self.screen_stack[-1].enter()
        else:
            self.running = False
    
    def go_back(self):
        """Convenience method to go back"""
        self.pop_screen()
    
    def run(self):
        """Main loop"""
        while self.running and self.screen_stack:
            current = self.screen_stack[-1]
            self.gui.poll_events()
            self.gui.update_delta()
            current.update(self.gui.delta)
            current.render()
            self.gui.present()
            time.sleep(0.02)

# ============================================================================
# MAIN
# ============================================================================

def main():
    """Application entry point"""
    logger = get_logger("main")
    logger.info("Starting Dolphin Rt:Core 'Frontendone'")

    print("🐬 DOLPHIN RT:CORE 'FRONTENDONE'")
    print("================================")
    print(f"Version: v11.00.00")
    print(f"Frontend Root: {FRONTEND_ROOT}")
    print()

    verifier = BootVerifier()
    verifier.verify_all()

    gui = SDL2GUI()
    if not gui.init():
        logger.critical("Failed to initialize SDL2")
        print("❌ Failed to initialize SDL2")
        sys.exit(1)

    try:
        app = App(gui)
        
        # Start with Boot Animation, then Main Menu
        boot = BootAnimation(app, gui)
        main_menu = MainMenu(app, gui)
        
        # Push both: boot first, then main menu
        # The boot screen will auto-pop when done
        app.push_screen(boot)
        app.push_screen(main_menu)  # This will be hidden behind boot animation
        
        # But we need a different approach: boot should be on top
        # Let's restructure: push main_menu first, then boot on top
        app.screen_stack = []  # Reset
        app.push_screen(main_menu)
        app.push_screen(boot)  # Boot is on top, will auto-pop
        
        app.run()
    except KeyboardInterrupt:
        logger.info("Interrupted by user")
        print("\n🛑 Interrupted by user")
    except Exception as e:
        logger.critical(f"Fatal error: {e}", exc_info=True)
        print(f"❌ Fatal error: {e}")
        import traceback
        traceback.print_exc()
    finally:
        gui.quit()
        FrontendLogger.log_shutdown()

if __name__ == "__main__":
    main()