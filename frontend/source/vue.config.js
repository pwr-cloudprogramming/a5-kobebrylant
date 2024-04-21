const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    proxy: {
      '^/': {
        target: 'http://52.200.231.173:8080',
        ws: true,
        changeOrigin: true
      }
    }
  }
})
