module.exports = function(api) {
  const validEnv = ['development', 'test', 'production']
  const currentEnv = api.env()

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
      'Please specify a valid `NODE_ENV` or ' +
        '`BABEL_ENV` environment variables. Valid values are "development", ' +
        '"test", and "production". Instead, received: ' +
        JSON.stringify(currentEnv) +
        '.'
    )
  }

  return {
    presets: [
      '@babel/preset-env'
    ],
    plugins: [
      '@babel/plugin-syntax-dynamic-import',
      '@babel/plugin-proposal-class-properties',
      ['@babel/plugin-proposal-object-rest-spread', { useBuiltIns: true }],
      // Supprimé le doublon et gardé une seule version avec les options
      ['@babel/plugin-transform-runtime', { helpers: false }]
    ]
  }
}
