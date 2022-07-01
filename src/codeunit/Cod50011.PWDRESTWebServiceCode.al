codeunit 50011 "PWD PWDRESTWebServiceCode"
{
    procedure CallRESTWebService(var Parameters: Record "PWD RESTWebServiceArguments"): Boolean
    var
        Client: HttpClient;
        AuthHeaderValue: HttpHeaders;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        TempBlob: Codeunit "Temp Blob";
    begin
        RequestMessage.Method := Format(Parameters.RestMethod);
        RequestMessage.SetRequestUri(Parameters.URL);

        RequestMessage.GetHeaders(Headers);

        if Parameters.Accept <> '' then
            Headers.Add('Accept', Parameters.Accept);

        if Parameters.ETag <> '' then
            Headers.Add('If-Match', Parameters.ETag);

        if Parameters.HasRequestContent then begin
            Parameters.GetRequestContent(Content);
            RequestMessage.Content := Content;
        end;

        Client.Send(RequestMessage, ResponseMessage);

        Headers := ResponseMessage.Headers;
        Parameters.SetResponseHeaders(Headers);

        Content := ResponseMessage.Content;
        Parameters.SetResponseContent(Content);

        EXIT(ResponseMessage.IsSuccessStatusCode);
    end;
}
