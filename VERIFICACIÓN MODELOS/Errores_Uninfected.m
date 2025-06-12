function Errores_Uninfected(T_Errores_Uninfected_Otsu, T_Errores_Uninfected_Canny, T_Errores_Uninfected_K_means, T_Errores_Uninfected_K_means_color)

    % Unificar resultados en una tabla
    metodo = {'Otsu'; 'Canny'; 'K-means'; 'K-means color'};
    Total_ruido = [T_Errores_Uninfected_Otsu.Total_ruido; T_Errores_Uninfected_Canny.Total_ruido; T_Errores_Uninfected_K_means.Total_ruido; T_Errores_Uninfected_K_means_color.Total_ruido];
    Media = [T_Errores_Uninfected_Otsu.Media; T_Errores_Uninfected_Canny.Media; T_Errores_Uninfected_K_means.Media; T_Errores_Uninfected_K_means_color.Media];
    Total_imagenes = [T_Errores_Uninfected_Otsu.Total_imagenes; T_Errores_Uninfected_Canny.Total_imagenes; T_Errores_Uninfected_K_means.Total_imagenes; T_Errores_Uninfected_K_means_color.Total_imagenes];
    
    Tabla_Uninfected_Errores = table(metodo, Total_ruido, Media, Total_imagenes);
    fprintf('\n===== RESUMEN DE ERRORES: Uninfected - Ruido =====\n\n');
    disp(Tabla_Uninfected_Errores)
    
    % Guardar como .csv
    writetable(Tabla_Uninfected_Errores, 'Resumen_Uninfected_Errores.csv');
end