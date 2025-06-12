function ruido_Uninfected_Otsu(carpetas_pacientes, carpetas_GT, nombre_resultado_csv, metodo)
        
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

                %====SEGMENTACIÓN===
                
                % 1. Filtro
                I_sinruido=medfilt2(I_gray, [3 3]);
            
                % 2. Umbral
                threshold = graythresh(I_sinruido)*0.95;
            
                % 3. Binarizar
                M1 = imbinarize(I_sinruido, threshold);
            
                % 4. Tener el negativo
                negativo= imcomplement(M1);
            
                % 5. Rellenar agujeros
                M2 = imfill(M1, 'holes');
            
                % 6. Separar WBCs
                WBC_mask_ruido = M2 & ~M1;
            
                % 7. Eliminar pequeños ruidos
                WBC_mask = bwareaopen(WBC_mask_ruido, 1500);

                % 8. Parasitos que se detecta cuando no debería de haber
                parasitos= negativo-WBC_mask;
        
                % ============VERIFICACIÓN DEL RUIDO=======
                
                % Obtención de caracteristicas del ruido
                n=8;
                CC = bwconncomp(parasitos, n);
                properties = regionprops(CC,I_gray, 'Centroid', 'Area', 'Perimeter','Circularity', ...
                    'Eccentricity', 'MajorAxisLength', 'MinorAxisLength', 'EquivDiameter');
        
                % Conteo del ruido
                ruido = size(properties, 1);
                total_ruido=total_ruido+ruido;
            end
        end
        evaluar_ruido_Uninfected(total_ruido, total_imagenes, metodo, nombre_resultado_csv);
end