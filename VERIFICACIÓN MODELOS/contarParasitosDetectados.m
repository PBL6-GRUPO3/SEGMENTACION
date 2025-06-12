function parasitos_detectados = contarParasitosDetectados(x_parasitos, y_parasitos, caracteristicas, umbral_distancia)

    parasitos_detectados = 0;
            
    % Lista para guardar cuáles detecciones ya fueron usadas
    detectados_usados = false(length(caracteristicas), 1);

    % Recorrer cada parásito real
    for c = 1:length(x_parasitos)
        centro_real = [x_parasitos(c), y_parasitos(c)];
        for d = 1:length(caracteristicas)
            if detectados_usados(d)
            continue;  % Saltar si esta detección ya fue usada
            end
            centro_detectado = caracteristicas(d).Centroid;
            distancia = norm(centro_real - centro_detectado);
            if distancia < umbral_distancia
                parasitos_detectados = parasitos_detectados + 1;
                detectados_usados(d) = true;
                break;  % Evita contar un parásito detectado más de una vez
            end
        end
    end
end