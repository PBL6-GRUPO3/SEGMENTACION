function ruido_Uninfected_K_means(carpetas_pacientes, carpetas_GT, nombre_resultado_csv, metodo)
        
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
                I_gray=im2double(rgb2gray(I));
                
                % Filtro
                I_sinruido=medfilt2(I_gray, [3 3]);
              
                % === K-means para segmentar ===
                I_reshape = reshape(I_sinruido, [], 1);
                [cluster_idx, cluster_centers] = kmeans(double(I_reshape), 3);
                segmented_image = reshape(cluster_idx, size(I_sinruido));
                dark_points_mask = segmented_image == min(segmented_image(:));  % zonas oscuras
                
                % === Glóbulos blancos sin ruido ===
                WBC_mask = bwareaopen(dark_points_mask, 500);
                
                parasite_candidate_mask = dark_points_mask & ~WBC_mask;  % quitar glóbulos blancos
                
                se = strel('disk', 2);  % Estructura de dilatación
                dilated_parasites = imdilate(parasite_candidate_mask, se);
                
                % === Preprocesar para detectar parásitos ===
                parasite_candidate_mask = imfill(dilated_parasites, 'holes');
                parasite_candidate_mask = imopen(dilated_parasites, strel('disk',1));
                
                % === Usar como máscara en la imagen original (opcional) ===
                mascara_parasitos = I_gray;
                mascara_parasitos(~dilated_parasites) = 0;  % fondo negro
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