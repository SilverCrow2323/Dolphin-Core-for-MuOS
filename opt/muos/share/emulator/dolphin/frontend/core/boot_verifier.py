#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
BOOT VERIFIER - Verify environment at boot
"""

import os

from core.logger import get_logger

class BootVerifier:
    """Verify environment at boot"""
    
    def __init__(self):
        self.logger = get_logger("boot_verifier")
        self.results = {}
        # Frontend root
        self.frontend_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    
    def verify_all(self):
        """Run all verifications"""
        self.logger.info("Running boot verification...")
        
        checks = [
            ("dolphin", self.verify_dolphin),
            ("config", self.verify_config),
            ("rom_paths", self.verify_rom_paths),
            ("profiles", self.verify_profiles),
            ("assets", self.verify_assets),
        ]
        
        all_ok = True
        for name, func in checks:
            ok = func()
            self.results[name] = ok
            if not ok:
                all_ok = False
        
        if all_ok:
            self.logger.info("✅ All boot checks passed")
        else:
            self.logger.warning("⚠️ Some boot checks failed")
        
        return all_ok
    
    def verify_dolphin(self):
        """Verify Dolphin emulator exists"""
        paths = [
            "/opt/muos/share/emulator/dolphin/dolphin",
            "/opt/muos/share/emulator/dolphin/dolphin.exe",
        ]
        for path in paths:
            if os.path.exists(path):
                self.logger.info(f"✅ Dolphin found: {path}")
                return True
        
        self.logger.warning("❌ Dolphin not found")
        return False
    
    def verify_config(self):
        """Verify config directory exists"""
        config_path = "/opt/muos/share/emulator/dolphin/Config"
        if os.path.exists(config_path):
            self.logger.info(f"✅ Config directory found: {config_path}")
            return True
        
        self.logger.warning(f"❌ Config directory not found: {config_path}")
        return False
    
    def verify_rom_paths(self):
        """Verify ROM paths exist"""
        paths = [
            "/mnt/mmc/ROMS/GC/",
            "/mnt/sdcard/ROMS/GC/",
            "/mnt/mmc/ROMS/Wii/",
            "/mnt/sdcard/ROMS/Wii/",
        ]
        
        found = False
        for path in paths:
            if os.path.exists(path):
                self.logger.info(f"✅ ROM path found: {path}")
                found = True
        
        if not found:
            self.logger.warning("⚠️ No ROM paths found")
            return False
        
        return True
    
    def verify_profiles(self):
        """Verify core profiles exist"""
        base_paths = [
            "/opt/muos/share/info/assign/Nintendo GameCube",
            "/opt/muos/share/info/assign/Nintendo Wii"
        ]
        profiles = ["standard.ini", "performance.ini", "compatibility.ini"]
        
        found = 0
        for base_path in base_paths:
            for profile in profiles:
                path = os.path.join(base_path, profile)
                if os.path.exists(path):
                    found += 1
        
        if found >= 1:
            self.logger.info(f"✅ Found {found} profiles")
            return True
        
        self.logger.warning("❌ No profiles found")
        return False
    
    def verify_assets(self):
        """Verify assets exist"""
        assets_dir = os.path.join(self.frontend_root, "assets")
        
        if not os.path.exists(assets_dir):
            self.logger.warning(f"❌ Assets directory not found: {assets_dir}")
            return False
        
        # Check fonts
        fonts_dir = os.path.join(assets_dir, "fonts")
        if not os.path.exists(fonts_dir):
            self.logger.warning(f"❌ Fonts directory not found")
            return False
        
        self.logger.info("✅ Assets verified")
        return True