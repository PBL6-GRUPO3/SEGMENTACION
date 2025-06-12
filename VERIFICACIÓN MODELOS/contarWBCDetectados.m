function wbc_detectados = contarWBCDetectados(x_wbc, y_wbc, caracteristicas, umbral_distancia)

    wbc_detectados = 0;  % Inicializar contador
    detectados_usados = false(length(caracteristicas), 1);  % Marcar detecciones ya usadas

    for d = 1:length(x_wbc)
        centro_real = [x_wbc(d), y_wbc(d)];
        for e = 1:length(caracteristicas)
            if detectados_usados(e)
                continue;  % Saltar si ya fue emparejado
            end
            centro_detectado = caracteristicas(e).Centroid;
            distancia = norm(centro_real - centro_detectado);
            if distancia < umbral_distancia
                wbc_detectados = wbc_detectados + 1;
                detectados_usados(e) = true;
                break;  % Salir del bucle para esta anotación
            end
        end
    end
end