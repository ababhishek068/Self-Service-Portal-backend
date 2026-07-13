table 50975 "Vendor Evaluation Lines"
{
    Caption = 'VendorEvaluation Lines';
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
            trigger OnValidate()
            var
            
            begin
                
            end;
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
            avscore: Decimal;
            countinglines: Integer;
            
            begin
                TestField(rate);
                Clear(avscore);
                Clear(countinglines);
                
                ratescales.Reset();
                ratescales.SetRange(ratescales."Rating Name", Rate);
                if ratescales.FindFirst() then begin
                    Value := ratescales.Value+1;
                    avscore:=0;
                countinglines:=0;
                vendorratelines.Reset();
                vendorratelines.SetRange(vendorratelines."Employee Code",rec."Employee Code");
                vendorratelines.SetRange(vendorratelines."Provider Code",rec."Provider Code");
                vendorratelines.SetRange(vendorratelines."Date Created",rec."Date Created");
                if vendorratelines.Find('-') then begin

                    repeat
                    countinglines:=countinglines+1;
                    avscore:=avscore+vendorratelines.Value;

                    until vendorratelines.Next=0;
                    
                    
                
                end;
                if (countinglines<>0) and (avscore<>0) then begin
                    vendorrateheader.Reset();
                    vendorrateheader.SetRange(vendorrateheader.Vendor,"Provider Code");
                    vendorrateheader.SetRange(vendorrateheader."Employee Code",rec."Employee Code");
                    vendorrateheader.SetRange(vendorrateheader."Date Created",rec."Date Created");
                    if vendorrateheader.FindFirst() then  begin
                        vendorrateheader."Average Score":=avscore/countinglines;
                        vendorrateheader.Modify;
                    end;
                end;
                

                    Validate(Value);
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
        vendorrateheader: Record "Vendor Evaluation Header";
        vendorratelines: Record "Vendor Evaluation Lines";
}
