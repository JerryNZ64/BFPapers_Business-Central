codeunit 50150 "WebShopAuthentication_WS"
{
    trigger OnRun()
    begin

    end;

    procedure CheckContactInfo(contactQuery: Text) ResponseObject: JsonObject
    var
        lContact: Record Contact;
        lContBusRel: Record "Contact Business Relation";
        queryList: JsonArray;
        queryToken: JsonToken;
        countErr: Boolean;
        queryObject: JsonObject;
        SuccessResponse: JsonObject;
        FailResponse: JsonObject;
        countErrTxt: TextConst ENZ = 'Detected multiple queries';
        contactEmail: Text;
        contactPwd: Text;
        contactFound: Boolean;
        contactPwdMatch: Boolean;
    begin
        contactQuery := CopyStr(contactQuery, StrPos(contactQuery, '['));
        contactQuery := CopyStr(contactQuery, 1, StrLen(contactQuery) - 1);
        if queryList.ReadFrom(contactQuery) then begin
            if queryList.Count > 1 then
                countErr := true
            else begin
                queryList.get(1, queryToken);
                queryObject := queryToken.AsObject;
                contactEmail := SelectJsonToken(queryObject, '$.E-mail');
                contactPwd := SelectJsonToken(queryObject, '$.Password');
                lContact.Reset();
                lContact.SetRange("E-Mail", contactEmail);
                lContact.SetRange(Type, lContact.Type::Person);
                if lContact.FindFirst() then begin
                    contactFound := true;
                    ResponseObject.Add('Session', format(CreateGuid()));
                    contactPwdMatch := (contactPwd = lContact.Password);

                    lContBusRel.SETCURRENTKEY("Link to Table", "No.");
                    lContBusRel.SETRANGE("Link to Table", lContBusRel."Link to Table"::Customer);
                    lContBusRel.SETRANGE("Contact No.", lContact."No.");

                    lContBusRel.FINDFIRST;
                END;
                COMMIT;

                // Cont.SETCURRENTKEY("Company Name","Company No.",Type,Name);
                // Cont.SETRANGE("Company No.",lContBusRel."Contact No.");

            end;

        end;
        exit(ResponseObject);
    end;

    local procedure SelectJsonToken(JsonObject: JsonObject; Path: text): text;
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.SelectToken(Path, JsonToken) then
            exit('');
        if JsonToken.AsValue.IsNull then
            exit('');
        exit(jsontoken.asvalue.astext);
    end;

}
