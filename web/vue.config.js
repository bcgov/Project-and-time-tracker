module.exports = {
  configureWebpack: {
    devtool: 'source-map',
  },

  // NOTE - ONLY FOR GitHub Pages! Any way to easily configure, maybe env var
  // Using ./ for GH pages - need to verify but turns paths relative
  // https://github.com/vuejs/vue-cli/issues/1623
  // baseUrl: './'
  baseUrl: '/Project-and-time-tracker/'
};
