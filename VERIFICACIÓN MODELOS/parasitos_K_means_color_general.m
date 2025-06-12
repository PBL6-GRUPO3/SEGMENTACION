function parasitos_K_means_color_general(carpetas_pacientes, carpetas_GT, nombre_resultado_csv, metodo, tipo_parasito)

    % Iniciar contadores
    total_parasitos_reales = 0;
    total_candidatos = 0;
    total_parasitos_detectados = 0;
    total_ruido = 0;

    for a = 1:length(carpetas_pacientes)

        % Carpetas de los pacientes
        imageFolder = carpetas_pacientes{a};

        % Carpetas de las anotaciones
        carpeta_GT = carpetas_GT{a};

        % Cargar imágenes del paciente actual
        imageFiles = dir(fullfile(imageFolder, '*.jpg'));

        for b = 1:length(imageFiles)
            % Nombre completo del archivo
            filename = fullfile(imageFolder, imageFiles(b).name);

            % Cargar la imagen
            I=imread(filename);
            
            % Binario y escala de grises
            I_gray=rgb2gray(I);
            
            % Filtro
            I_sinruido=medfilt2(I_gray, [3 3]);
            
            % Aplicar imsegkmeans directamente (necesita uint8 o single)
            [L, cluster_centers] = imsegkmeans(I_sinruido, 3);
        
            mean_intensity = zeros(3,1);
            for c = 1:3
                mean_intensity(c) = mean(I_sinruido(L==c), 'all');
            end
            [~, idx_darkest] = min(mean_intensity);
            dark_points_mask = L == idx_darkest;
            
            % === Filtrar WBC (regiones grandes) ===
            WBC_mask = bwareaopen(dark_points_mask, 500);
            parasite_candidate_mask = dark_points_mask & ~WBC_mask;
            
            % === Procesamiento morfológico ===
            se = strel('disk', 2);
            dilated = imdilate(parasite_candidate_mask, se);
            filled = imfill(dilated, 'holes');
            opened = imopen(filled, strel('disk',1));
            
            % === Preparar imagen para imfindcircles ===
            mascara_parasitos = im2double(I_gray);
            mascara_parasitos(~opened) = 0;  % Fondo negro

            % === Carpetas de las anotaciones ===
            % Nombre de la imagen
            nombre_imagen_actual = imageFiles(b).name(1:end-4);

            % Quitar guiones y guiones bajos para buscar archivos sin formato
            nombre_sin_separadores = erase(nombre_imagen_actual, {'-', '_'});
            
            % Ruta anotación sin separar
            ruta_GT_sin_separadores = fullfile(carpeta_GT, [nombre_sin_separadores, '.txt']);
            
            % Ruta anotación con guiones
            ruta_GT_con_formato = fullfile(carpeta_GT, [nombre_imagen_actual, '.txt']);
            
            % Usar el archivo que exista
            if isfile(ruta_GT_sin_separadores)
                ruta_GT = ruta_GT_sin_separadores;
            elseif isfile(ruta_GT_con_formato)
                ruta_GT = ruta_GT_con_formato;
            else
                continue;  % Saltar esta imagen
            end

            % Leer anotaciones
            datos = readtable(ruta_GT, 'Delimiter', ',', 'HeaderLines', 1);

            % Filtrar solo las anotaciones de parásitos según el tipo
            if strcmpi(tipo_parasito, 'PF')
                % Para Plasmodium falciparum
                solo_parasitos = datos(strcmp(datos.Var2, 'Parasite'), :);

                if ismember('Var8', datos.Properties.VariableNames) && ismember('Var9', datos.Properties.VariableNames)
                    x_parasitos = (solo_parasitos.Var6 + solo_parasitos.Var8) / 2;
                    y_parasitos = (solo_parasitos.Var7 + solo_parasitos.Var9) / 2;
                else
                    continue;
                end

            elseif strcmpi(tipo_parasito, 'PV')
                % Para Plasmodium vivax
                solo_parasitos = datos(strcmp(datos.Var2, 'Parasitized'), :);
                x_parasitos = solo_parasitos.Var6;
                y_parasitos = solo_parasitos.Var7;
            end

            % ============VERIFICAR SEGMENTACIÓN========

            % Extraer el numero de parasitos
            numero_de_parasitos= size(solo_parasitos,1);
        
            % Candidatos a parasitos
            n=8;
            CC = bwconncomp(mascara_parasitos,n);
            properties = {'Centroid', 'Circularity', 'Area','Eccentricity', 'Solidity'};
            caracteristicas = regionprops(CC,I_gray,properties);
            candidatos_a_parasitos=size(caracteristicas,1);
        
            % Parasitos detectados
            umbral_distancia = 50;
            parasitos_detectados=contarParasitosDetectados(x_parasitos, y_parasitos, caracteristicas, umbral_distancia);

            % Ruido en cada imagen
            ruido = candidatos_a_parasitos - parasitos_detectados;

            % Sumas de los parasitos reales, candidatos, detectados y
            % ruidos
            total_parasitos_reales = total_parasitos_reales + numero_de_parasitos;
            total_candidatos = total_candidatos + candidatos_a_parasitos;
            total_parasitos_detectados = total_parasitos_detectados + parasitos_detectados;
            total_ruido = total_ruido + ruido;
        end
    end
    % Obtener resultados de precisión y sensibilidad
    evaluar_parasitos(total_parasitos_detectados, total_candidatos, total_parasitos_reales, metodo, nombre_resultado_csv);
end
