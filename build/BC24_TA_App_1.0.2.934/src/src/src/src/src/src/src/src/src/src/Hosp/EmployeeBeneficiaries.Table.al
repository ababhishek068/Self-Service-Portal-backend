Table 50147 "Employee Beneficiaries"
{
    Caption = 'Employee Relative';
    // DrillDownPageID = UnknownPage70135478;
    // LookupPageID = UnknownPage70135478;

    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "HR-Employee"."No.";
        }
        field(2; Relationship; Code[20])
        {
            NotBlank = true;
            TableRelation = Relative.Code;

            trigger OnValidate()
            begin
                Clear(counts);
                benf.Reset;
                benf.SetRange(benf."Employee Code", "Employee Code");
                benf.SetFilter(benf."Entry No", '<>%1', '');
                if benf.Find('-') then begin
                    counts := benf.Count;
                    "Entry No" := Format(counts + 1);
                end else begin
                    counts := 0;
                    "Entry No" := Format(counts + 1);
                end;
            end;
        }
        field(3; SurName; Text[50])
        {
            NotBlank = true;
        }
        field(4; "Other Names"; Text[100])
        {
            NotBlank = true;
        }
        field(5; "ID No/Passport No"; Text[50]) { }
        field(6; "Date Of Birth"; Date) { }
        field(7; Occupation; Text[100]) { }
        field(8; Address; Text[250]) { }
        field(9; "Office Tel No"; Text[100]) { }
        field(10; "Home Tel No"; Text[50]) { }
        field(11; Remarks; Text[250]) { }
        field(12; "Entry No"; Code[10]) { }
    }

    keys
    {
        key(Key1; "Entry No", "Employee Code") { }
        key(Key2; "Employee Code", SurName, "Other Names")
        {
            Clustered = true;
        }
    }

    fieldgroups { }

    trigger OnDelete()
    var
        HRCommentLine: Record "Human Resource Comment Line";
    begin
        HRCommentLine.SetRange("Table Name", HRCommentLine."table name"::"Employee Relative");
        HRCommentLine.SetRange("No.", "Employee Code");
        HRCommentLine.DeleteAll;
    end;

    var
        benf: Record "Employee Beneficiaries";
        counts: Integer;
}

