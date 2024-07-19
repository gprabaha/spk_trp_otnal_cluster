function generateSingleChanPermScript(IDStr, regionStr, cp, savePath)
    FID = fopen(savePath, 'w');
    fprintf(FID, '%%Auto-generated at %s\n', datestr(now, 'mmmm dd, yyyy HH:MM:SS.FFF AM'));
    fprintf(FID, 'IDStr = ''%s'';\n', IDStr);
    fprintf(FID, 'regionStr = ''%s'';\n', regionStr);
    fprintf(FID, 'cp = %d;\n', cp);
    fprintf(FID, '%s\n', 'generateShuffledTripletsForChanPerm(IDStr, regionStr, cp);');
    fclose(FID);
end