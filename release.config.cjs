/**
 * @type {import('semantic-release').GlobalConfig}
 */

// define here all assets which should included in a release
const assets = [
  { path: "dist/xbashio.zip", label: "xbashio-${nextRelease.version}.zip" },
];

let plugins = [
  [
    "@semantic-release/commit-analyzer",
    {
      preset: "conventionalcommits",
    },
  ],
  [
    "@semantic-release/release-notes-generator",
    {
      preset: "conventionalcommits",
    },
  ],
  [
    "@semantic-release/npm",
    {
      npmPublish: false,
    },
  ],
  [
    "@semantic-release/git",
    {
      assets: ["package.json"],
      message:
        "chore(release): ${nextRelease.version} [skip ci] [skip release]\n\n${nextRelease.notes}",
    },
  ],
];

if (!process.env.NPM_TOKEN) {
  // Token is not needed because we do not publish to a npm registry
  process.env.NPM_TOKEN = "adummytoken";
}

if (process.env.CI === "true") {
  if (process.env.GITHUB_SERVER_URL === "https://github.com") {
    plugins = [
      ...plugins,
      [
        "@semantic-release/github",
        {
          assets: [...assets],
        },
      ],
    ];
  } else {
    plugins = [
      ...plugins,
      [
        "@saithodev/semantic-release-gitea",
        {
          assets: [...assets],
        },
      ],
    ];
  }
}

module.exports = {
  branches: [
    {
      name: "main",
      channel: "stable",
    },
    {
      name: "next",
      channel: "next",
      prerelease: "next",
    },
  ],
  ci: process.env.CI === "true",
  plugins: [...plugins],
};
