table 50968 "Trainer Evaluation Lines"
{
    Caption = 'TrainerEvaluation Lines';
    DataClassification = ToBeClassified;


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
        field(5; "Provider Code"; Code[20])
        {
            Caption = 'Provider';
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
                countinglines:=0;
                avscore:=0;
                ratescales.Reset();
                ratescales.SetRange(ratescales."Rating Name", Rate);
                if ratescales.FindFirst() then begin
                    Value := ratescales.Value;
                    evaluationlines.Reset();
                    evaluationlines.SetRange(evaluationlines."Course code",Rec."Course code");
                    evaluationlines.SetRange(evaluationlines."Training Need",rec."Training Need");
                    evaluationlines.SetRange(evaluationlines."Provider Code",rec."Provider Code");
                    evaluationlines.SetRange(evaluationlines."Employee Code",rec."Employee Code");
                    if evaluationlines.Find('-') then begin
                        repeat
                        countinglines:=countinglines+1;
                        avscore:=avscore+evaluationlines.Value;
                        

                        until evaluationlines.next=0;
                    end;

                end;
                if (countinglines<>0) and (avscore<>0) then begin
                    vendorrateheader.Reset();
                    vendorrateheader.SetRange(vendorrateheader.Trainer,"Provider Code");
                    vendorrateheader.SetRange(vendorrateheader."Employee Code",rec."Employee Code");
                    vendorrateheader.SetRange(vendorrateheader."Training Need",rec."Training Need");
                    vendorrateheader.SetRange(vendorrateheader."Course Code",rec."Course code");
                    //vendorrateheader.SetRange(vendorrateheader."Date Created",rec."Date Created");
                    if vendorrateheader.FindFirst() then  begin
                        vendorrateheader."Average Score":=avscore/countinglines;
                        vendorrateheader.Modify;
                    end;
                end;

            end;
        }
        field(30; "Course code"; code[20]) { }
        field(31; "Training Need"; code[20]) { }
        field(32; "Date Created"; Date) { }


    }
    keys
    {
        key(PK; "Employee Code", "Provider Code", "Rate Code", "Course code", "Training Need")
        {
            Clustered = true;
        }
    }
    var
        ratescales: Record "Probation Rating Scale";
        vendorrateheader: Record "Trainer Evaluation Header";
        evaluationlines: Record "Trainer Evaluation Lines";
}
