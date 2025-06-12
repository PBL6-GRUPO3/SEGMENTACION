function ruido_Uninfected_K_means_color(carpetas_pacientes, carpetas_GT, nombre_resultado_csv, metodo)
        
        % Inizializar el conteo
        total_imagenes = 0;
        total_ruido=0;
        for a = 1:length(carpetas_pacientes)
        
            % Carpetas de los pacientes
            imageFolder = carpetas_pacientes{a};
        
            % Carpetas de las anotaciones
            carpeta_GT = carpetas_GT{a};
        
            % Cargar imágenes del paciente actual
            imageFiles = dir(fullfile(imageFolder, '*.tiff'));

            % Acumulador de imagenes
            total_imagenes = total_imagenes + length(imageFiles);
        
            for b = 1:length(imageFiles)
                % Nombre completo del archivo
                filename = fullfile(imageFolder, imageFiles(b).name);

                % Quitar las advertencias de Jpeg
                warning('off', 'all');
        
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
                % ============VERIFICACIÓN DEL RUIDO=======
                
                % Obtención de caracteristicas del ruido
                n=8;
                CC = bwconncomp(mascara_parasitos, n);
                properties = regionprops(CC,I_gray, 'Centroid', 'Area', 'Perimeter','Circularity', ...
                    'Eccentricity', 'MajorAxisLength', 'MinorAxisLength', 'EquivDiameter');
        
                % Conteo del ruido
                ruido = size(properties, 1);
                total_ruido=total_ruido+ruido;
            end
        end
        evaluar_ruido_Uninfected(total_ruido, total_imagenes, metodo, nombre_resultado_csv);
end