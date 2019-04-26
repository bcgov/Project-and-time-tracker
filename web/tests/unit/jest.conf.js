const path = require('path');

module.exports = {
  rootDir: path.resolve(__dirname, '../../'),
  moduleFileExtensions: [
    'js',
    'json',
    'vue',
  ],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1',
  },
  transform: {
    '^.+\\.js$': '<rootDir>/node_modules/babel-jest',
    '.*\\.(vue)$': '<rootDir>/node_modules/vue-jest',
  },
  testMatch: [
   
  
     "**/src/components/**/IntakeFormsTable.test.(js)",
     "**/src/components/**/IntakeRequests.test.(js)",
   // '**/src/components/**/IntakeFormView.test.(js)',
    '**/src/components/**/IntakeBaseInfoView.test.(js)',
    '**/src/components/**/IntakeSuccess.test.(js)',
    "**/src/components/**/IntakeBaseInfo.test.(js)",
    '**/src/components/**/ProjectAdditionalContactInfoView.test.(js)',
    '**/src/components/**/ProjectContactInfoView.test.(js)',
    // "**/src/components/**/IntakeForm.test.(js)",
    '**/src/components/**/Projects.test.(js)',
    '**/src/components/**/ProjectFinanceInfo.test.(js)',
    // "**/src/components/**/IntakeRequests.test.(js)",
     "**/src/components/**/AddNewTimeRecord.test.(js)"
  ],
  testURL: 'http://localhost/',
  snapshotSerializers: ['<rootDir>/node_modules/jest-serializer-vue'],
  setupFiles: ['<rootDir>/tests/unit/setup','<rootDir>/node_modules/regenerator-runtime/runtime'],
  mapCoverage: true,
 // collectCoverage: true,
  coverageDirectory: '<rootDir>/tests/unit/coverage',
  collectCoverageFrom: [
    'src/**/*.{js,vue}',
    '!src/main.js',
    '!src/**/*.test.js',
    '!src/router/index.js',
    '!**/node_modules/**',
  ],
};
