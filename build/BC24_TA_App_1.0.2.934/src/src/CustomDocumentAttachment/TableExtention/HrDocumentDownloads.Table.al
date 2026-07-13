table 51007 "Hr Document Downloads"
{
    Caption = 'Hr Document Downloads';
    DataClassification = ToBeClassified;
    
    fields
    {
        field(1; "Document No"; Code[30])
        {
            Caption = 'Document No';
        }
        field(2; "Document Category"; Enum "Doc. Attachment Cateogory")
        {
            Caption = 'Document Category';
        }
        field(3; "Document Description"; Text[150])
        {
            Caption = 'Document Description';
        }
        field(4; Publish; Boolean)
        {
            Caption = 'Publish';
        }
    }
    keys
    {
        key(PK; "Document No")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
        HRSetup: Record "HR Setup";
        NoSeries: Codeunit "No. Series";
    begin
        HRSetup.Get();
        HRSetup.TestField("HR Document Nos");

        if "Document No" = '' then begin
            "Document No" := NoSeries.GetNextNo(HRSetup."HR Document Nos", Today, true);
        end;    
    end;
}
