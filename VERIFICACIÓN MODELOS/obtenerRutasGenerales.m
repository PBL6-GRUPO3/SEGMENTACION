function tabla_rutas = obtenerRutasGenerales(tipo, carpeta_base_pacientes, carpeta_base_GT)

    % Obtener subcarpetas válidas
    subcarpetas = dir(carpeta_base_pacientes);
    subcarpetas = subcarpetas([subcarpetas.isdir] & ~startsWith({subcarpetas.name}, '.'));

    % Ordenar pacientes por número extraído del nombre para PF y PV
    if strcmp(tipo, 'PF')
        nombres = {subcarpetas.name};
        numeros = zeros(length(nombres), 1);
        for i = 1:length(nombres)
            tokens = regexp(nombres{i}, 'TF(\d+)', 'tokens');
            if ~isempty(tokens)
                numeros(i) = str2double(tokens{1}{1});
            end
        end
        [~, orden] = sort(numeros);
        subcarpetas = subcarpetas(orden);

    elseif strcmp(tipo, 'PV')
        nombres = {subcarpetas.name};
        numeros = zeros(length(nombres), 1);
        for i = 1:length(nombres)
            tokens = regexp(nombres{i}, 'PvTk(\d+)', 'tokens');
            if ~isempty(tokens)
                numeros(i) = str2double(tokens{1}{1});
            end
        end
        [~, orden] = sort(numeros);
        subcarpetas = subcarpetas(orden);
    end

    rutas_imagenes = {};
    rutas_gt = {};
    pacientes_validos = {};

    for i = 1:length(subcarpetas)
        nombre_paciente = subcarpetas(i).name;

        switch tipo
            case 'Uninfected'
                ruta_imagenes = fullfile(carpeta_base_pacientes, nombre_paciente, 'tiled');
                ruta_gt_base = fullfile(carpeta_base_GT, nombre_paciente, 'results');
                if exist(ruta_gt_base, 'dir')
                    subdirs = dir(ruta_gt_base);
                    subdirs = subdirs([subdirs.isdir] & ~startsWith({subdirs.name}, '.'));
                    if ~isempty(subdirs)
                        ruta_gt = fullfile(ruta_gt_base, subdirs(1).name);  % primer subdirectorio
                    else
                        ruta_gt = '';
                    end
                else
                    ruta_gt = '';
                end
                rutas_imagenes{end+1,1} = ruta_imagenes;
                rutas_gt{end+1,1} = ruta_gt;
                pacientes_validos{end+1,1} = nombre_paciente;

            case 'PF'
                ruta_imagenes = fullfile(carpeta_base_pacientes, nombre_paciente);
                ruta_gt = fullfile(carpeta_base_GT, nombre_paciente);
                if exist(ruta_gt, 'dir')
                    archivos_gt = dir(fullfile(ruta_gt, '*.txt'));
                    if ~isempty(archivos_gt)
                        rutas_imagenes{end+1,1} = ruta_imagenes;
                        rutas_gt{end+1,1} = ruta_gt;
                        pacientes_validos{end+1,1} = nombre_paciente;
                    end
                end

            case 'PV'
                ruta_imagenes = fullfile(carpeta_base_pacientes, nombre_paciente);
                ruta_gt = fullfile(carpeta_base_GT, nombre_paciente);
                rutas_imagenes{end+1,1} = ruta_imagenes;
                if exist(ruta_gt, 'dir')
                    rutas_gt{end+1,1} = ruta_gt;
                else
                    rutas_gt{end+1,1} = '';
                end
                pacientes_validos{end+1,1} = nombre_paciente;
        end
    end

    % Crear tabla con columna 'Paciente' siempre
    tabla_rutas = table(rutas_imagenes, rutas_gt, pacientes_validos, ...
        'VariableNames', {'RutaImagenes', 'RutaAnotaciones', 'Paciente'});
end