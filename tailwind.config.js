module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  plugins: [
    require('daisyui')
  ],
  daisyui: {
    themes: [
      "cupcake"
    ],
  },
  theme: {
    extend: {
      colors: {
        ash: '#999999' // カスタムカラーを追加
      },
    },
  },
}
