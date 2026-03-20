'use client';

import React, { createContext, useContext, useState, useEffect } from 'react';
import { useRouter } from 'next/navigation';
import api, { setAccessToken } from '@/lib/api';

interface User {
  id: string;
  email: string;
}

interface AuthContextType {
  user: User | null;
  login: (token: string, user: User) => void;
  logout: () => void;
  loading: boolean;
}

const AuthContext = createContext<AuthContextType | null>(null);

export const AuthProvider = ({ children }: { children: React.ReactNode }) => {
  const [user, setUser] = useState<User | null>(null);
  const [loading, setLoading] = useState(true);
  const router = useRouter();

  useEffect(() => {
    console.log('[AUTH] useEffect - Start');
    
    // Safety: Force loading to false after 5 seconds
    const timer = setTimeout(() => {
      console.warn('[AUTH] useEffect - Loading timeout reached, forcing false');
      setLoading(false);
    }, 5000);

    // Expose force load for debugging
    if (typeof window !== 'undefined') {
      (window as any).FORCE_LOAD_AUTH = () => {
        console.log('[AUTH] Force load triggered manually');
        setLoading(false);
      };
    }

    try {
      if (typeof window !== 'undefined') {
        const storedUser = localStorage.getItem('user');
        const storedToken = localStorage.getItem('accessToken');
        
        console.log('[AUTH] useEffect - Stored User:', storedUser ? 'Yes' : 'No');
        console.log('[AUTH] useEffect - Stored Token:', storedToken ? 'Yes' : 'No');

        if (storedUser && storedToken) {
          try {
            const parsedUser = JSON.parse(storedUser);
            console.log('[AUTH] useEffect - Parsed User:', parsedUser.email);
            setUser(parsedUser);
            setAccessToken(storedToken);
          } catch (e) {
            console.error('[AUTH] useEffect - Parse Error:', e);
            localStorage.removeItem('user');
            localStorage.removeItem('accessToken');
          }
        }
      }
    } catch (e) {
      console.error('[AUTH] useEffect - Storage Error:', e);
    } finally {
      console.log('[AUTH] useEffect - Setting loading to false');
      setLoading(false);
      clearTimeout(timer);
    }
  }, []);

  const login = (token: string, user: User) => {
    console.log('[AUTH] login - Start:', user.email);
    setAccessToken(token);
    setUser(user);
    localStorage.setItem('user', JSON.stringify(user));
    console.log('[AUTH] login - Redirecting to /');
    router.push('/');
  };

  const logout = async () => {
    try {
      await api.post('/auth/logout');
    } catch (e) {}
    setAccessToken(null);
    setUser(null);
    localStorage.removeItem('user');
    router.push('/login');
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (!context) throw new Error('useAuth must be used within AuthProvider');
  return context;
};
