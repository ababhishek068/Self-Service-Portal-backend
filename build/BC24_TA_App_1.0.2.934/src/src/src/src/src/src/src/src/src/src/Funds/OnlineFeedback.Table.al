Table 50762 "Online Feedback"
{

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "User Name"; Code[20])
        {
            Editable = false;
            NotBlank = true;
            TableRelation = "Online Sessions"."User Name";
        }
        field(4; Date; DateTime)
        {
            Editable = false;
            NotBlank = true;
        }
        field(5; Comment; Text[250])
        {
            Editable = false;
            NotBlank = true;
        }
        field(6; Response; Text[250])
        {

            trigger OnValidate()
            begin
                s := '';
                s := Response;

                if Response <> '' then begin
                    Status := Status::Read;
                    Modify;

                    /*
                       IF s<>'' THEN BEGIN     feedbackResponse:='The administrator responded to your question/feedback: '+"Administrator Response";
                              SendEML(feedbackResponse,'no-reply@localhost',s,'RE: Feedback');
                         MESSAGE('Thank you for responding to the question/feedback. An e-mail alert has been sent to %1.',s);
                       END;
                       */
                end;

            end;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionMembers = "Not Read",Read;
        }
        field(8; "Sender Email"; Text[250])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
        key(Key2; "User Name") { }
        key(Key3; Date) { }
    }

    fieldgroups { }

    var
        s: Text[80];
}

