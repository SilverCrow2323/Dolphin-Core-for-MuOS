#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
SDL2 GUI WRAPPER - ctypes bindings for SDL2 on muOS
Zero dependencies, pure Python + SDL2 via ctypes
"""

import ctypes
import os
import sys
import time
from ctypes import c_int, c_void_p, c_char_p, c_uint32, c_float, c_double

# ============================================================================
# LOAD SDL2 LIBRARIES
# ============================================================================

def load_sdl_libraries():
    """Load SDL2 and related libraries"""
    libs = {}
    
    # Try different paths for muOS
    sdl_paths = [
        "/usr/lib/libSDL2-2.0.so.0",
        "/usr/lib/libSDL2.so",
        "/usr/lib/aarch64-linux-gnu/libSDL2-2.0.so.0",
        "/opt/muos/lib/libSDL2-2.0.so.0",
    ]
    
    sdl_ttf_paths = [
        "/usr/lib/libSDL2_ttf-2.0.so.0",
        "/usr/lib/libSDL2_ttf.so",
        "/usr/lib/aarch64-linux-gnu/libSDL2_ttf-2.0.so.0",
    ]
    
    sdl_image_paths = [
        "/usr/lib/libSDL2_image-2.0.so.0",
        "/usr/lib/libSDL2_image.so",
        "/usr/lib/aarch64-linux-gnu/libSDL2_image-2.0.so.0",
    ]
    
    sdl_mixer_paths = [
        "/usr/lib/libSDL2_mixer-2.0.so.0",
        "/usr/lib/libSDL2_mixer.so",
        "/usr/lib/aarch64-linux-gnu/libSDL2_mixer-2.0.so.0",
    ]
    
    # Find and load SDL2
    for path in sdl_paths:
        if os.path.exists(path):
            libs['sdl2'] = ctypes.CDLL(path)
            break
    else:
        raise ImportError("Could not find SDL2 library")
    
    # Find and load SDL2_ttf
    for path in sdl_ttf_paths:
        if os.path.exists(path):
            libs['sdl2_ttf'] = ctypes.CDLL(path)
            break
    
    # Find and load SDL2_image
    for path in sdl_image_paths:
        if os.path.exists(path):
            libs['sdl2_image'] = ctypes.CDLL(path)
            break
    
    # Find and load SDL2_mixer
    for path in sdl_mixer_paths:
        if os.path.exists(path):
            libs['sdl2_mixer'] = ctypes.CDLL(path)
            break
    
    return libs

# Load libraries
_LIBS = load_sdl_libraries()

# ============================================================================
# SDL2 CONSTANTS
# ============================================================================

# Window flags
SDL_WINDOW_FULLSCREEN = 0x00000001
SDL_WINDOW_FULLSCREEN_DESKTOP = 0x00001001
SDL_WINDOW_SHOWN = 0x00000004
SDL_WINDOW_HIDDEN = 0x00000008
SDL_WINDOW_BORDERLESS = 0x00000010
SDL_WINDOW_RESIZABLE = 0x00000020

# Renderer flags
SDL_RENDERER_SOFTWARE = 0x00000001
SDL_RENDERER_ACCELERATED = 0x00000002
SDL_RENDERER_PRESENTVSYNC = 0x00000004
SDL_RENDERER_TARGETTEXTURE = 0x00000008

# Key codes (solo quelli che ci servono)
SDLK_UP = 1073741906
SDLK_DOWN = 1073741905
SDLK_LEFT = 1073741904
SDLK_RIGHT = 1073741903
SDLK_RETURN = 13
SDLK_ESCAPE = 27
SDLK_BACKSPACE = 8
SDLK_TAB = 9
SDLK_SPACE = 32
SDLK_a = 97
SDLK_b = 98
SDLK_x = 120
SDLK_y = 121
SDLK_s = 115
SDLK_f = 102
SDLK_m = 109
SDLK_r = 114
SDLK_t = 116
SDLK_q = 113
SDLK_w = 119
SDLK_e = 101

# Event types
SDL_QUIT = 0x100
SDL_KEYDOWN = 0x300
SDL_KEYUP = 0x301
SDL_TEXTINPUT = 0x302
SDL_MOUSEMOTION = 0x400
SDL_MOUSEBUTTONDOWN = 0x401
SDL_MOUSEBUTTONUP = 0x402
SDL_MOUSEWHEEL = 0x403
SDL_CONTROLLERAXISMOTION = 0x600
SDL_CONTROLLERBUTTONDOWN = 0x601
SDL_CONTROLLERBUTTONUP = 0x602
SDL_CONTROLLERDEVICEADDED = 0x603
SDL_CONTROLLERDEVICEREMOVED = 0x604
SDL_CONTROLLERDEVICEREMAPPED = 0x605

# Controller buttons
SDL_CONTROLLER_BUTTON_A = 0
SDL_CONTROLLER_BUTTON_B = 1
SDL_CONTROLLER_BUTTON_X = 2
SDL_CONTROLLER_BUTTON_Y = 3
SDL_CONTROLLER_BUTTON_BACK = 4
SDL_CONTROLLER_BUTTON_GUIDE = 5
SDL_CONTROLLER_BUTTON_START = 6
SDL_CONTROLLER_BUTTON_DPAD_UP = 11
SDL_CONTROLLER_BUTTON_DPAD_DOWN = 12
SDL_CONTROLLER_BUTTON_DPAD_LEFT = 13
SDL_CONTROLLER_BUTTON_DPAD_RIGHT = 14

# ============================================================================
# SDL2 FUNCTION BINDINGS
# ============================================================================

class SDL2GUI:
    """SDL2 GUI wrapper using ctypes"""
    
    def __init__(self):
        self.sdl2 = _LIBS.get('sdl2')
        self.ttf = _LIBS.get('sdl2_ttf')
        self.image = _LIBS.get('sdl2_image')
        self.mixer = _LIBS.get('sdl2_mixer')
        
        self.window = None
        self.renderer = None
        self.width = 0
        self.height = 0
        self.running = False
        self.delta = 0
        self.last_time = 0
        
        # Font cache
        self.fonts = {}
        
        # Texture cache
        self.textures = {}
        
        # Sound cache
        self.sounds = {}
        
        # Controller state
        self.controllers = {}
        self.keys_pressed = set()
        self.mouse_x = 0
        self.mouse_y = 0
        self.mouse_buttons = set()
        
        # Input callbacks
        self.key_down_callbacks = []
        self.key_up_callbacks = []
        self.mouse_callbacks = []
    
    # ========================================================================
    # INITIALIZATION
    # ========================================================================
    
    def init(self, title="Dolphin Rt:Core 'Frontendone'", fullscreen=True):
        """Initialize SDL2"""
        # SDL_Init (VIDEO | AUDIO)
        if self.sdl2.SDL_Init(0x00000001 | 0x00000020) != 0:
            return False
        
        # TTF_Init
        if self.ttf and self.ttf.TTF_Init() != 0:
            pass
        
        # IMG_Init (PNG | JPG)
        if self.image:
            self.image.IMG_Init(0x00000001 | 0x00000002)
        
        # Get desktop display mode
        display_mode = ctypes.c_void_p()
        if self.sdl2.SDL_GetDesktopDisplayMode(0, ctypes.byref(display_mode)) == 0:
            self.width = display_mode.w
            self.height = display_mode.h
        
        # Create window
        flags = SDL_WINDOW_FULLSCREEN_DESKTOP if fullscreen else SDL_WINDOW_SHOWN
        self.window = self.sdl2.SDL_CreateWindow(
            title.encode('utf-8'),
            0x2FFF0000,
            0x2FFF0000,
            0, 0,
            flags
        )
        
        if not self.window:
            return False
        
        # Create renderer
        self.renderer = self.sdl2.SDL_CreateRenderer(
            self.window,
            -1,
            SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC
        )
        
        if not self.renderer:
            self.renderer = self.sdl2.SDL_CreateRenderer(
                self.window,
                -1,
                SDL_RENDERER_SOFTWARE
            )
            
        if not self.renderer:
            return False
        
        # Get window size
        w = ctypes.c_int()
        h = ctypes.c_int()
        self.sdl2.SDL_GetWindowSize(self.window, ctypes.byref(w), ctypes.byref(h))
        self.width = w.value
        self.height = h.value
        
        # Init audio if mixer available
        if self.mixer:
            self.mixer.Mix_OpenAudio(44100, 0x8010, 2, 4096)
        
        self.running = True
        self.last_time = time.time()
        
        return True
    
    def quit(self):
        """Clean up SDL2 resources"""
        if self.mixer:
            self.mixer.Mix_CloseAudio()
            self.mixer.Mix_Quit()
        if self.image:
            self.image.IMG_Quit()
        if self.ttf:
            self.ttf.TTF_Quit()
        if self.renderer:
            self.sdl2.SDL_DestroyRenderer(self.renderer)
        if self.window:
            self.sdl2.SDL_DestroyWindow(self.window)
        self.sdl2.SDL_Quit()
        self.running = False
    
    # ========================================================================
    # RENDERING
    # ========================================================================
    
    def clear(self, r=0, g=0, b=0, a=255):
        """Clear the screen"""
        self.sdl2.SDL_SetRenderDrawColor(self.renderer, r, g, b, a)
        self.sdl2.SDL_RenderClear(self.renderer)
    
    def present(self):
        """Present the renderer"""
        self.sdl2.SDL_RenderPresent(self.renderer)
    
    def get_size(self):
        """Get window size"""
        return self.width, self.height
    
    def draw_rect(self, x, y, w, h, r, g, b, a=255, fill=True):
        """Draw a rectangle"""
        self.sdl2.SDL_SetRenderDrawColor(self.renderer, r, g, b, a)
        rect = (x, y, w, h)
        if fill:
            self.sdl2.SDL_RenderFillRect(self.renderer, rect)
        else:
            self.sdl2.SDL_RenderDrawRect(self.renderer, rect)
    
    def draw_line(self, x1, y1, x2, y2, r, g, b, a=255):
        """Draw a line"""
        self.sdl2.SDL_SetRenderDrawColor(self.renderer, r, g, b, a)
        self.sdl2.SDL_RenderDrawLine(self.renderer, x1, y1, x2, y2)
    
    def draw_texture(self, texture, x, y, w=None, h=None):
        """Draw a texture"""
        if w is None:
            w = texture.width
        if h is None:
            h = texture.height
        rect = (x, y, w, h)
        self.sdl2.SDL_RenderCopy(self.renderer, texture.ptr, None, rect)
    
    def draw_texture_scaled(self, texture, x, y, w, h):
        """Draw a texture scaled"""
        rect = (x, y, w, h)
        self.sdl2.SDL_RenderCopy(self.renderer, texture.ptr, None, rect)
    
    # ========================================================================
    # TEXTURE LOADING
    # ========================================================================
    
    def load_texture(self, path):
        """Load a texture from file"""
        if not self.image or not os.path.exists(path):
            return None
        
        surf = self.image.IMG_Load(path.encode('utf-8'))
        if not surf:
            return None
        
        tex = self.sdl2.SDL_CreateTextureFromSurface(self.renderer, surf)
        if not tex:
            return None
        
        w = ctypes.c_int()
        h = ctypes.c_int()
        self.sdl2.SDL_QueryTexture(tex, None, None, ctypes.byref(w), ctypes.byref(h))
        
        self.sdl2.SDL_FreeSurface(surf)
        
        return Texture(tex, w.value, h.value)
    
    def create_texture_from_surface(self, surf):
        """Create texture from surface"""
        tex = self.sdl2.SDL_CreateTextureFromSurface(self.renderer, surf)
        w = ctypes.c_int()
        h = ctypes.c_int()
        self.sdl2.SDL_QueryTexture(tex, None, None, ctypes.byref(w), ctypes.byref(h))
        return Texture(tex, w.value, h.value)
    
    # ========================================================================
    # FONT LOADING
    # ========================================================================
    
    def load_font(self, path, size):
        """Load a font"""
        if not self.ttf:
            return None
        
        key = f"{path}:{size}"
        if key in self.fonts:
            return self.fonts[key]
        
        font = self.ttf.TTF_OpenFont(path.encode('utf-8'), size)
        if font:
            self.fonts[key] = font
        return font
    
    def render_text(self, font, text, r, g, b, a=255):
        """Render text to a surface"""
        if not font or not text:
            return None
        
        color = (r, g, b, a)
        surf = self.ttf.TTF_RenderUTF8_Blended(font, text.encode('utf-8'), color)
        return surf
    
    # ========================================================================
    # INPUT
    # ========================================================================
    
    def poll_events(self):
        """Poll SDL events"""
        event = ctypes.c_void_p()
        while self.sdl2.SDL_PollEvent(ctypes.byref(event)):
            self._handle_event(event)
    
    def _handle_event(self, event):
        """Handle a single event"""
        etype = event.type
        
        if etype == SDL_QUIT:
            self.running = False
        
        elif etype == SDL_KEYDOWN:
            key = event.key.keysym.sym
            self.keys_pressed.add(key)
            for cb in self.key_down_callbacks:
                cb(key)
        
        elif etype == SDL_KEYUP:
            key = event.key.keysym.sym
            self.keys_pressed.discard(key)
            for cb in self.key_up_callbacks:
                cb(key)
        
        elif etype == SDL_MOUSEBUTTONDOWN:
            self.mouse_buttons.add(event.button.button)
        
        elif etype == SDL_MOUSEBUTTONUP:
            self.mouse_buttons.discard(event.button.button)
    
    def is_key_pressed(self, key):
        """Check if a key is pressed"""
        return key in self.keys_pressed
    
    def on_key_down(self, callback):
        """Register a key down callback"""
        self.key_down_callbacks.append(callback)
    
    def on_key_up(self, callback):
        """Register a key up callback"""
        self.key_up_callbacks.append(callback)
    
    # ========================================================================
    # AUDIO
    # ========================================================================
    
    def load_sound(self, path):
        """Load a sound file"""
        if not self.mixer or not os.path.exists(path):
            return None
        
        sound = self.mixer.Mix_LoadWAV(path.encode('utf-8'))
        return sound
    
    def play_sound(self, sound, loops=0):
        """Play a sound"""
        if sound:
            self.mixer.Mix_PlayChannel(-1, sound, loops)
    
    # ========================================================================
    # UTILITY
    # ========================================================================
    
    def update_delta(self):
        """Update delta time"""
        current = time.time()
        self.delta = current - self.last_time
        self.last_time = current
        return self.delta
    
    def create_surface(self, width, height, r=0, g=0, b=0, a=255):
        """Create a surface"""
        return Surface(width, height, r, g, b, a)


class Texture:
    """SDL2 Texture wrapper"""
    def __init__(self, ptr, width, height):
        self.ptr = ptr
        self.width = width
        self.height = height


class Surface:
    """SDL2 Surface wrapper"""
    def __init__(self, width, height, r=0, g=0, b=0, a=255):
        self.width = width
        self.height = height
        self.r = r
        self.g = g
        self.b = b
        self.a = a
        self.data = bytearray(width * height * 4)