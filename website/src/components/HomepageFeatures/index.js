import clsx from 'clsx';
import Heading from '@theme/Heading';
import useBaseUrl from '@docusaurus/useBaseUrl';
import styles from './styles.module.css';

const FeatureList = [
  {
    title: 'Generate Projects in One Command',
    image: '/img/feature-generate.svg',
    description: (
      <>
        Create a ready-to-build C++ project skeleton with consistent structure,
        presets, and install rules, so new repos start fast and clean.
      </>
    ),
  },
  {
    title: 'Modern CMake, Less Boilerplate',
    image: '/img/feature-cmake.svg',
    description: (
      <>
        Use kmcmake macros to define libraries, binaries, tests, and benchmarks
        with readable declarations instead of repetitive raw CMake blocks.
      </>
    ),
  },
  {
    title: 'Built for Real-World Toolchains',
    image: '/img/feature-toolchain.svg',
    description: (
      <>
        Works with cross-platform builds and common dependency workflows, while
        keeping packaging and export conventions aligned across teams.
      </>
    ),
  },
];

function Feature({image, title, description}) {
  const imageUrl = useBaseUrl(image);
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <img src={imageUrl} className={styles.featureSvg} alt={title} />
      </div>
      <div className="text--center padding-horiz--md">
        <Heading as="h3">{title}</Heading>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}