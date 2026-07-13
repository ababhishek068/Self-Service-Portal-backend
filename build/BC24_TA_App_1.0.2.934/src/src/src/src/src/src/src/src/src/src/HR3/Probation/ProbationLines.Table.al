table 50959 "Probation Lines"
{
    Caption = 'Probation Lines';
    DataClassification = ToBeClassified;
    DrillDownPageId = "Probation lines";


    fields
    {
        field(1; "Employee Code"; Code[20])
        {
            Caption = 'Employee Code';
        }
        field(2; "Rate Code"; Integer)
        {
            Caption = 'Rate Code';
        }
        field(3; "Rate Factor"; Text[100])
        {
            Caption = 'Rate Factor';
        }
        field(4; "Value"; Integer)
        {
            Caption = 'Value';
        }
        field(5; "Job Id"; Code[20])
        {
            Caption = 'Job Id';
        }
        field(6; Rate; Option)

        {
            OptionMembers ="",Excellent,"Very Good",Good,Fair,"Below Expectation";
            //TableRelation="Probation Rating Scale"."Rating Name";
            trigger OnValidate()
            var
            countinglines: Integer;
            avscore: Decimal;
            begin
                ratescales.Reset();
                ratescales.SetRange(ratescales."Rating Name", Rate);
                if ratescales.FindFirst() then begin
                    Value := ratescales.Value;
                    probationlines.Reset();
                    probationlines.SetRange(probationlines."probation code",rec."probation code");
                    probationlines.SetRange(probationlines."Job Id",rec."Job Id");
                    probationlines.SetRange(probationlines."Employee Code",rec."Employee Code");
                    if probationlines.Find('-') then begin
                        repeat
                        countinglines:=countinglines+1;
                        avscore:=avscore+probationlines.Value;

                        until probationlines.next=0;
                    end;
                end;
                 if (countinglines<>0) and (avscore<>0) then begin
                    vendorrateheader.Reset();
                    vendorrateheader.SetRange(vendorrateheader."Probation Code",rec."probation code");
                    vendorrateheader.SetRange(vendorrateheader."Employee No",rec."Employee Code");
                    vendorrateheader.SetRange(vendorrateheader."Job ID",rec."Job Id");
                   // vendorrateheader.SetRange(vendorrateheader."Course Code",rec."Course code");
                    //vendorrateheader.SetRange(vendorrateheader."Date Created",rec."Date Created");
                    if vendorrateheader.FindFirst() then  begin
                        clear(vendorrateheader."Average Score");
                        vendorrateheader."Average Score":=avscore/countinglines;
                        vendorrateheader.Modify;
                    end;
                end;

            end;
        }
        field(30; "probation code"; code[20]) { }
    }
    keys
    {
        key(PK; "Employee Code", "Job Id", "Rate Code","probation code")
        {
            Clustered = true;
        }
    }
    var
        ratescales: Record "Probation Rating Scale";
        vendorrateheader: Record "Probation Header";
        probationlines: Record "Probation Lines";
}
