#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
CENTRALIZED LOGGER - Logging system for all Python modules
"""

import os
import sys
import logging
from logging.handlers import RotatingFileHandler

class FrontendLogger:
    """Centralized logger for the entire frontend"""
    
    _instances = {}
    _log_dir = None
    _log_level = logging.INFO
    
    @classmethod
    def initialize(cls, log_dir=None, log_level="INFO"):
        """Initialize the logging system"""
        if log_dir is None:
            log_dir = os.environ.get("DOLPHIN_FRONTEND_LOG_DIR")
            if not log_dir:
                # Fallback: usa la directory data/logs/frontend relativa al frontend
                frontend_root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
                log_dir = os.path.join(frontend_root, "data", "logs", "frontend")
        
        cls._log_dir = log_dir
        os.makedirs(log_dir, exist_ok=True)
        
        level_map = {
            "DEBUG": logging.DEBUG,
            "INFO": logging.INFO,
            "WARN": logging.WARNING,
            "ERROR": logging.ERROR,
            "CRITICAL": logging.CRITICAL,
        }
        cls._log_level = level_map.get(log_level.upper(), logging.INFO)
    
    @classmethod
    def get_logger(cls, module_name):
        """Get a logger instance for a specific module"""
        if module_name not in cls._instances:
            cls._instances[module_name] = cls._create_logger(module_name)
        return cls._instances[module_name]
    
    @classmethod
    def _create_logger(cls, module_name):
        """Create a new logger with file and console handlers"""
        logger = logging.getLogger(f"dolphin_frontend.{module_name}")
        logger.setLevel(cls._log_level)
        
        if logger.handlers:
            return logger
        
        formatter = logging.Formatter(
            '[%(asctime)s] [%(module)s] [%(levelname)s] %(message)s',
            datefmt='%Y-%m-%d %H:%M:%S'
        )
        
        log_file = os.path.join(cls._log_dir, f"{module_name}.log")
        file_handler = RotatingFileHandler(
            log_file,
            maxBytes=5*1024*1024,  # 5 MB
            backupCount=3
        )
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
        
        # Console handler (solo warning e superiori sul terminale)
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(formatter)
        console_handler.setLevel(logging.WARNING)
        logger.addHandler(console_handler)
        
        return logger
    
    @classmethod
    def log_startup(cls):
        """Log application startup information"""
        logger = cls.get_logger("system")
        logger.info("=" * 70)
        logger.info("🐬 DOLPHIN RT:CORE 'FRONTENDONE' - STARTUP")
        logger.info("=" * 70)
        logger.info(f"Version: v11.00.00")
        logger.info(f"Log directory: {cls._log_dir}")
        logger.info(f"Log level: {logging.getLevelName(cls._log_level)}")
        logger.info(f"Python version: {sys.version}")
        logger.info(f"Platform: {sys.platform}")
        logger.info("=" * 70)
    
    @classmethod
    def log_shutdown(cls):
        """Log application shutdown"""
        logger = cls.get_logger("system")
        logger.info("=" * 70)
        logger.info("🛑 DOLPHIN RT:CORE 'FRONTENDONE' - SHUTDOWN")
        logger.info("=" * 70)

def get_logger(module_name):
    """Convenience function to get a logger"""
    return FrontendLogger.get_logger(module_name)