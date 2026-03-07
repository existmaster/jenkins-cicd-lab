import reactHooks from 'eslint-plugin-react-hooks'
import react from 'eslint-plugin-react'

export default [
  {
    files: ['src/**/*.{js,jsx}'],
    languageOptions: {
      parserOptions: {
        ecmaVersion: 'latest',
        sourceType: 'module',
        ecmaFeatures: {
          jsx: true,
        },
      },
    },
    plugins: { 'react-hooks': reactHooks, react },
    rules: {
      'no-unused-vars': 'warn',
      'no-console': 'off',
      'react-hooks/rules-of-hooks': 'error',
      'react-hooks/exhaustive-deps': 'warn',
      'react/jsx-uses-react': 'off',
      'react/jsx-uses-vars': 'error',
    },
  },
]
