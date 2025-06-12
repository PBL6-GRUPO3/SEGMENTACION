function wbc_Otsu_general(carpetas_pacientes, carpetas_GT, extension, sufijo_recorte, nombre_resultado_csv, metodo)
    
    % Inicializar variables de conteo
    total_wbc_reales = 0;
    total_candidatos = 0;
    total_wbc_detectados = 0;
    total_ruido_wbc_sano = 0;
    
    for a = 1:length(carpetas_pacientes)
        
        % Carpetas de los pacientes
        imageFolder = carpetas_pacientes{a};
        
        % Carpetas de las anotaciones
        carpeta_GT = carpetas_GT{a};
        
        % Cargar imágenes del paciente actual con la extensión correspondiente
        imageFiles = dir(fullfile(imageFolder, ['*.', extension]));
        
        for b = 1:length(imageFiles)

            % Nombre completo del archivo
            filename = fullfile(imageFolder, imageFiles(b).name);     

            %=====Modelo de segmentación=======
            % Quitar las advertencias de Jpeg
            warning('off', 'all');
            % Cargar la imagen
            I = imread(filename);
    
            % Binario y escala de grises
            I_gray = im2double(rgb2gray(I));
    
            % 1. Filtro
            I_sinruido = medfilt2(I_gray, [3 3]);
    
            % ======APLICAR OTSU=====
            % 2. Umbral automático (Otsu)
            umbral = graythresh(I_sinruido) * 0.95;

            % 3. Binarizar
            M1 = imbinarize(I_sinruido, umbral);
            
            % 4. Rellenar agujeros
            M2 = imfill(M1, 'holes');
            
            % 5. Separar glóbulos blancos (restar la máscara binaria original)
            globulos_blancos_ruido = M2 & ~M1;
            
            % 6. Eliminar pequeños ruidos
            globulos_blancos = bwareaopen(globulos_blancos_ruido, 1500); 

            % === Carpetas de las anotaciones corregidas ===
            % Eliminar extensión ('.jpg' = 4, '.tiff' = 5)
            nombre_txt = imageFiles(b).name(1:end - sufijo_recorte);
            ruta_GT = fullfile(carpeta_GT, [nombre_txt, '.txt']);

            % Verificar si el archivo existe
            if ~isfile(ruta_GT)
                continue;  % Saltar esta imagen y seguir con la siguiente
            end

            % Leer anotaciones
            datos = readtable(ruta_GT, 'Delimiter', ',', 'HeaderLines', 1);

            % ===== GLÓBULOS BLANCOS =====
            if ~isempty(datos) && any(strcmp(datos.Var2, 'White_Blood_Cell'))
                solo_WBC = datos(strcmp(datos.Var2, 'White_Blood_Cell'), :);
            
                if width(solo_WBC) >= 7
                    x_wbc = solo_WBC.Var6;
                    y_wbc = solo_WBC.Var7;
                end
            else
                solo_WBC = [];
                x_wbc = [];
                y_wbc = [];
            end

            % ============VERIFICAR SEGMENTACIÓN========
            % Extraer el número de WBC reales
            numero_de_wbc = size(solo_WBC, 1);
            n = 8; % conectividad

            % Candidatos a WBC detectados por segmentación
            CC = bwconncomp(globulos_blancos, n);
            properties = {'Centroid', 'Circularity', 'Area','Eccentricity', 'Solidity'};
            caracteristicas = regionprops(CC, I_gray, properties);
            candidatos_a_wbc = size(caracteristicas, 1);

            % wbc detectados (verificados por cercanía a anotaciones)
            umbral_distancia = 50;
            wbc_detectados = contarWBCDetectados(x_wbc, y_wbc, caracteristicas, umbral_distancia);
            
            % Mostrar ruido en cada imagen
            ruido = candidatos_a_wbc - wbc_detectados;

            % Sumas de los wbc reales, candidatos y detectados 
            total_wbc_reales = total_wbc_reales + numero_de_wbc;
            total_candidatos = total_candidatos + candidatos_a_wbc;
            total_wbc_detectados = total_wbc_detectados + wbc_detectados;
            total_ruido_wbc_sano = total_ruido_wbc_sano + ruido;
        end
    end
    
    % Obtener resultados de precisión y sensibilidad
    evaluar_wbc(total_wbc_detectados, total_candidatos, total_wbc_reales, metodo, nombre_resultado_csv);
end