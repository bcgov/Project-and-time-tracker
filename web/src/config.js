// const baseUrl = 'http://localhost:3333';
const baseUrl = process.env.NODE_ENV === 'development'
  ? 'http://localhost:3333'
  : `${window.location.origin}/api`;

const config = {
  locale: 'en-US', // en-US, zh-CN
  url: baseUrl,
  ajaxUploadUrl: `${baseUrl}/admin/api/upload`,
  debug: {
    mock: true, // enable mock
    http: false, // http request log
  },
  api: `${baseUrl}/admin/api`,
  // locale: 'en', //en
  // api: 'http://192.168.1.108:3333/admin/api'
};

global.config = config;

export default config;
