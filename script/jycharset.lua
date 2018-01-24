local iconv = require("iconv")
function createIconv(from,to,text)
  local cd = iconv.new(to .. "//TRANSLIT", from);
  local ostr, err = cd:iconv(text);
  if err == iconv.ERROR_INCOMPLETE then
    return "ERROR: Incomplete input.";
  elseif err == iconv.ERROR_INVALID then
    return "ERROR: Invalid input.";
  elseif err == iconv.ERROR_NO_MEMORY then
    return "ERROR: Failed to allocate memory.";
  elseif err == iconv.ERROR_UNKNOWN then
    return "ERROR: There was an unknown error.";
  end
  return ostr;
end

function change_charsert(str, flag)
    if flag == 0 then
        return createIconv("big5" , "utf-8", str);
    elseif flag == 1 then
        return createIconv("utf-8" , "big5", str);
    elseif flag == 2 then
        return createIconv("big5" , "unicode", str);
    else
        return createIconv("utf-8" , "unicode", str);
    end
end

-- ��ȡutf8Ӧ��ռ�õĿ��,һ�����ӿ�2��,Ӣ����ĸ��1��,utf8���볤�Ȳ�������תΪgbkֱ�ӻ�ȡ����
-- gbk�к���2�ֽ� Ӣ��1�ֽ�
function get_show_width(input)
    return #createIconv("utf-8" , "gbk", input);
end
