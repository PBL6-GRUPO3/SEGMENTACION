function Resumen_PV_Parasitos(T_Parasitos_PV_Otsu, T_Parasitos_PV_Canny, T_Parasitos_PV_K_means, T_Parasitos_PV_K_means_color)

    % Unificar resultados en una tabla
    metodo = {'Otsu'; 'Canny'; 'K-means'; 'K-means color'};
    TP = [T_Parasitos_PV_Otsu.TP; T_Parasitos_PV_Canny.TP; T_Parasitos_PV_K_means.TP; T_Parasitos_PV_K_means_color.TP];
    FP = [T_Parasitos_PV_Otsu.FP; T_Parasitos_PV_Canny.FP; T_Parasitos_PV_K_means.FP; T_Parasitos_PV_K_means_color.FP];
    FN = [T_Parasitos_PV_Otsu.FN; T_Parasitos_PV_Canny.FN; T_Parasitos_PV_K_means.FN; T_Parasitos_PV_K_means_color.FN];
    Precision = [T_Parasitos_PV_Otsu.Precision; T_Parasitos_PV_Canny.Precision; T_Parasitos_PV_K_means.Precision; T_Parasitos_PV_K_means_color.Precision];
    Sensibilidad = [T_Parasitos_PV_Otsu.Sensibilidad; T_Parasitos_PV_Canny.Sensibilidad; T_Parasitos_PV_K_means.Sensibilidad; T_Parasitos_PV_K_means_color.Sensibilidad];
    
    Tabla_PV_Parasitos = table(metodo, TP, FP, FN, Precision, Sensibilidad);
    fprintf('\n===== RESUMEN DE RESULTADOS: PV - Parásitos =====\n\n');
    disp(Tabla_PV_Parasitos)
    
    % Guardar como .csv
    writetable(Tabla_PV_Parasitos, 'Resumen_PV_Parasitos.csv');
end