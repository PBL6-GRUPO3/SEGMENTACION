function Resumen_PF_Parasitos(T_Parasitos_PF_Otsu, T_Parasitos_PF_Canny, T_Parasitos_PF_K_means, T_Parasitos_PF_K_means_color)

    % Unificar resultados en una tabla
    metodo = {'Otsu'; 'Canny'; 'K-means'; 'K-means color'};
    TP = [T_Parasitos_PF_Otsu.TP; T_Parasitos_PF_Canny.TP; T_Parasitos_PF_K_means.TP; T_Parasitos_PF_K_means_color.TP];
    FP = [T_Parasitos_PF_Otsu.FP; T_Parasitos_PF_Canny.FP; T_Parasitos_PF_K_means.FP; T_Parasitos_PF_K_means_color.FP];
    FN = [T_Parasitos_PF_Otsu.FN; T_Parasitos_PF_Canny.FN; T_Parasitos_PF_K_means.FN; T_Parasitos_PF_K_means_color.FN];
    Precision = [T_Parasitos_PF_Otsu.Precision; T_Parasitos_PF_Canny.Precision; T_Parasitos_PF_K_means.Precision; T_Parasitos_PF_K_means_color.Precision];
    Sensibilidad = [T_Parasitos_PF_Otsu.Sensibilidad; T_Parasitos_PF_Canny.Sensibilidad; T_Parasitos_PF_K_means.Sensibilidad; T_Parasitos_PF_K_means_color.Sensibilidad];
    
    Tabla_PF_Parasitos = table(metodo, TP, FP, FN, Precision, Sensibilidad);
    fprintf('\n===== RESUMEN DE RESULTADOS: PF - Parásitos =====\n\n');
    disp(Tabla_PF_Parasitos)
    
    % Guardar como .csv
    writetable(Tabla_PF_Parasitos, 'Resumen_PF_Parasitos.csv');
end