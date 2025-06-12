function Resumen_PF_WBC(T_WBC_PF_Otsu, T_WBC_PF_Canny, T_WBC_PF_K_means, T_WBC_PF_K_means_color)

    % Unificar resultados en una tabla
    metodo = {'Otsu'; 'Canny'; 'K-means'; 'K-means color'};
    TP = [T_WBC_PF_Otsu.TP; T_WBC_PF_Canny.TP; T_WBC_PF_K_means.TP; T_WBC_PF_K_means_color.TP];
    FP = [T_WBC_PF_Otsu.FP; T_WBC_PF_Canny.FP; T_WBC_PF_K_means.FP; T_WBC_PF_K_means_color.FP];
    FN = [T_WBC_PF_Otsu.FN; T_WBC_PF_Canny.FN; T_WBC_PF_K_means.FN; T_WBC_PF_K_means_color.FN];
    Precision = [T_WBC_PF_Otsu.Precision; T_WBC_PF_Canny.Precision; T_WBC_PF_K_means.Precision; T_WBC_PF_K_means_color.Precision];
    Sensibilidad = [T_WBC_PF_Otsu.Sensibilidad; T_WBC_PF_Canny.Sensibilidad; T_WBC_PF_K_means.Sensibilidad; T_WBC_PF_K_means_color.Sensibilidad];
    
    Tabla_PF_WBC = table(metodo, TP, FP, FN, Precision, Sensibilidad);
    fprintf('\n===== RESUMEN DE RESULTADOS: PF - WBC =====\n\n');
    disp(Tabla_PF_WBC)
    
    % Guardar como .csv
    writetable(Tabla_PF_WBC, 'Resumen_PF_WBC.csv');
end