import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue2';
import path from 'path';

export default defineConfig({
  plugins: [vue()],
  server: {
    port:  8080,
  },
  envPrefix: 'VUE_APP_',
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src')
    },
    extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue']
  }
});