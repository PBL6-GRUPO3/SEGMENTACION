function ruido_Uninfected_Canny(carpetas_pacientes, carpetas_GT, nombre_resultado_csv, metodo)
        
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
              
                % Pasarlo a escala de grises
                I_gray = rgb2gray(I);
            
                % Quitar ruido
                I_sinruido=medfilt2(I_gray, [3 3]);
                
                % Detección de bordes
                BW = edge(I_sinruido, 'Canny',[0.05 0.4]);
                
                % Cerrar los contornos
                BW = imclose(BW, strel('disk', 40));
                
                % Revisar las propiedades
                CC = bwconncomp(BW,8);
                properties = {'Centroid', 'Circularity', 'Area','Eccentricity', 'Solidity'};
                stats = regionprops(CC,properties);
                
                % Define umbrales de área
                area_min = 200;
                area_max = max([stats.Area]); 
                
                % Crear nueva máscara basada en área
                BW_filtrada_area = false(size(BW));
                labeled_area = labelmatrix(CC);
                
                for c = 1:length(stats)
                    area = stats(c).Area;
                 
                    if area >= area_min && area <= area_max
                        BW_filtrada_area = BW_filtrada_area | (labeled_area == c);
                    end
                end
                
                % Reemplazar máscara con la filtrada por área
                globulos_blancos = BW_filtrada_area;
            
                % Mascara de parasitos
                mascara_parasitos=BW-globulos_blancos;
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