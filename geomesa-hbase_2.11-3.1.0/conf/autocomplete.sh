_geomesa-hbase(){
  local cur prev;
  COMPREPLY=();
  cur="${COMP_WORDS[COMP_CWORD]}";
  prev="${COMP_WORDS[COMP_CWORD-1]}";

  if [[ "${COMP_WORDS[1]}" == "help" ]]; then
    COMPREPLY=( $(compgen -W "create-schema delete-catalog delete-features manage-partitions remove-schema update-schema export playback bulk-ingest bulk-load ingest stats-analyze stats-bounds stats-count stats-top-k stats-histogram describe-schema explain get-sft-config get-type-names version-remote convert configure classpath env gen-avro-schema help scala-console version" ${cur}));
    return 0;
  fi;

  case ${COMP_CWORD} in
    1)
      COMPREPLY=( $(compgen -W "create-schema delete-catalog delete-features manage-partitions remove-schema update-schema export playback bulk-ingest bulk-load ingest stats-analyze stats-bounds stats-count stats-top-k stats-histogram describe-schema explain get-sft-config get-type-names version-remote convert configure classpath env gen-avro-schema help scala-console version" ${cur}));
      ;;
    [2-9] | [1-9][0-9])
      if [[ "${cur}" =~ ^-[a-zA-Z-]?+$ ]]; then
        case ${COMP_WORDS[1]} in
                    create-schema)
              COMPREPLY=( $(compgen -W "--spec --zookeepers --compression --feature-name --catalog --no-remote-filters --secure --authorizations --dtg" -- ${cur}));
              return 0;
              ;;
                  delete-catalog)
              COMPREPLY=( $(compgen -W "--authorizations --secure --catalog --zookeepers --force" -- ${cur}));
              return 0;
              ;;
                  delete-features)
              COMPREPLY=( $(compgen -W "--zookeepers --secure --cql --feature-name --authorizations --force --catalog" -- ${cur}));
              return 0;
              ;;
                  manage-partitions)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
                  remove-schema)
              COMPREPLY=( $(compgen -W "--pattern --force --catalog --authorizations --feature-name --zookeepers --secure" -- ${cur}));
              return 0;
              ;;
                  update-schema)
              COMPREPLY=( $(compgen -W "--enable-stats --authorizations --feature-name --add-attribute --no-backup --rename-attribute --catalog --force --remove-keyword --secure --add-user-data --rename --rename-tables --zookeepers --add-keyword" -- ${cur}));
              return 0;
              ;;
                  export)
              COMPREPLY=( $(compgen -W "--force --zookeepers --num-reducers --attributes --hints --chunk-size --authorizations --output-format --cql --sort-descending --secure --sort-by --no-remote-filters --index --run-mode --no-header --max-features --feature-name --output --gzip --attribute --catalog" -- ${cur}));
              return 0;
              ;;
                  playback)
              COMPREPLY=( $(compgen -W "--hints --attribute --cql --attributes --interval --secure --no-header --catalog --output --zookeepers --run-mode --sort-descending --sort-by --force --dtg --num-reducers --authorizations --chunk-size --no-remote-filters --output-format --gzip --max-features --step-window --rate --feature-name" -- ${cur}));
              return 0;
              ;;
                  bulk-ingest)
              COMPREPLY=( $(compgen -W "--no-remote-filters --run-mode --split-max-size --secure --converter --force --spec --feature-name --src-list --zookeepers --authorizations --output --no-tracking --threads --converter-error-mode --input-format --index --catalog --combine-inputs" -- ${cur}));
              return 0;
              ;;
                  bulk-load)
              COMPREPLY=( $(compgen -W "--validate --zookeepers --input --index --catalog --secure --authorizations --feature-name" -- ${cur}));
              return 0;
              ;;
                  ingest)
              COMPREPLY=( $(compgen -W "--no-remote-filters --run-mode --split-max-size --secure --converter --force --spec --feature-name --src-list --zookeepers --authorizations --no-tracking --threads --converter-error-mode --input-format --catalog --combine-inputs" -- ${cur}));
              return 0;
              ;;
                  stats-analyze)
              COMPREPLY=( $(compgen -W "--authorizations --no-remote-filters --catalog --zookeepers --feature-name --secure" -- ${cur}));
              return 0;
              ;;
                  stats-bounds)
              COMPREPLY=( $(compgen -W "--attributes --catalog --no-cache --no-remote-filters --secure --cql --authorizations --feature-name --zookeepers" -- ${cur}));
              return 0;
              ;;
                  stats-count)
              COMPREPLY=( $(compgen -W "--no-remote-filters --no-cache --authorizations --cql --catalog --secure --zookeepers --feature-name" -- ${cur}));
              return 0;
              ;;
                  stats-top-k)
              COMPREPLY=( $(compgen -W "--cql --no-cache --attributes --secure --no-remote-filters --zookeepers --feature-name --authorizations --catalog" -- ${cur}));
              return 0;
              ;;
                  stats-histogram)
              COMPREPLY=( $(compgen -W "--feature-name --cql --attributes --secure --no-remote-filters --authorizations --bins --no-cache --catalog --zookeepers" -- ${cur}));
              return 0;
              ;;
                  describe-schema)
              COMPREPLY=( $(compgen -W "--feature-name --catalog --authorizations --zookeepers --no-remote-filters --secure" -- ${cur}));
              return 0;
              ;;
                  explain)
              COMPREPLY=( $(compgen -W "--hints --authorizations --cql --secure --feature-name --no-remote-filters --zookeepers --index --attributes --catalog" -- ${cur}));
              return 0;
              ;;
                  get-sft-config)
              COMPREPLY=( $(compgen -W "--catalog --zookeepers --concise --exclude-user-data --feature-name --no-remote-filters --secure --format --authorizations" -- ${cur}));
              return 0;
              ;;
                  get-type-names)
              COMPREPLY=( $(compgen -W "--no-remote-filters --catalog --secure --authorizations --zookeepers" -- ${cur}));
              return 0;
              ;;
                  version-remote)
              COMPREPLY=( $(compgen -W "--secure --zookeepers --authorizations --catalog" -- ${cur}));
              return 0;
              ;;
                  convert)
              COMPREPLY=( $(compgen -W "--attributes --cql --output --num-reducers --run-mode --spec --feature-name --attribute --hints --converter --gzip --no-header --sort-by --output-format --max-features --chunk-size --input-format --sort-descending --converter-error-mode --force" -- ${cur}));
              return 0;
              ;;
                  configure)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
                  classpath)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
                  env)
              COMPREPLY=( $(compgen -W "--concise --converters --list-sfts --describe-sfts --exclude-user-data --format --sfts --list-converters --describe-converters" -- ${cur}));
              return 0;
              ;;
                  gen-avro-schema)
              COMPREPLY=( $(compgen -W "--spec --feature-name" -- ${cur}));
              return 0;
              ;;
                  help)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
                  scala-console)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
                  version)
              COMPREPLY=( $(compgen -W "" -- ${cur}));
              return 0;
              ;;
              esac;
      else
        compopt -o filenames -o nospace;
        COMPREPLY=( $(compgen -f "$2") );
      fi;
      return 0;
      ;;
    *)
      COMPREPLY=();
      ;;
  esac;
};
complete -F _geomesa-hbase geomesa-hbase;
complete -F _geomesa-hbase bin/geomesa-hbase;


       