function Resumen_Uninfected(T_Uninfected_Otsu,T_Uninfected_Canny,T_Uninfected_K_means,T_Uninfected_K_means_color)
    
    % Unificar resultados en una tabla
    metodo = {'Otsu'; 'Canny'; 'K-means'; 'K-means color'};
    TP = [T_Uninfected_Otsu.TP; T_Uninfected_Canny.TP; T_Uninfected_K_means.TP; T_Uninfected_K_means_color.TP];
    FP = [T_Uninfected_Otsu.FP; T_Uninfected_Canny.FP; T_Uninfected_K_means.FP; T_Uninfected_K_means_color.FP];
    FN = [T_Uninfected_Otsu.FN; T_Uninfected_Canny.FN; T_Uninfected_K_means.FN; T_Uninfected_K_means_color.FN];
    Precision = [T_Uninfected_Otsu.Precision; T_Uninfected_Canny.Precision; T_Uninfected_K_means.Precision; T_Uninfected_K_means_color.Precision];
    Sensibilidad = [T_Uninfected_Otsu.Sensibilidad; T_Uninfected_Canny.Sensibilidad; T_Uninfected_K_means.Sensibilidad; T_Uninfected_K_means_color.Sensibilidad];
    
    Tabla_Uninfected = table(metodo, TP, FP, FN, Precision, Sensibilidad);
    fprintf('\n===== RESUMEN DE RESULTADOS: Uninfected - WBC =====\n\n');
    disp(Tabla_Uninfected)
    
    % Guardar como .csv
    writetable(Tabla_Uninfected, 'Resumen_Uninfected.csv');
end