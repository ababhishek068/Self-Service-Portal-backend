
page 51469 EmployeeOrgChartAdvanced
{
    Caption='Organizational Structure';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "HR Jobs";
    
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(IndentedName; IndentedNameText)
                {
                    ApplicationArea = All;
                }
                field(Title; "Job ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
    var
        IndentedNameText: Text;

    trigger OnAfterGetRecord()
    begin
        IndentedNameText := GetIndentedName(Rec.Id);
    end;

    local procedure GetIndentedName(EmployeeId: Integer): Text
    var
        Hrjobs: Record "HR Jobs";
        ManagerId: Integer;
        Indentation: Integer;
        ReportsTo: Code[20];
    begin
        Indentation := 0;
        ReportsTo := Rec."Position Reporting to"; // Assuming Reports To is the field with the Manager's employee ID
        
        // Loop up the hierarchy to find the root and count levels for indentation
        while ReportsTo <> '' do
        begin
            Hrjobs.SetRange(Id, EmployeeId);
            if Hrjobs.FindFirst() then
            begin
                ReportsTo := Hrjobs."Position Reporting to";
                Indentation += 1;
            end
            else
            begin
                ReportsTo := '';
            end;
        end;
        
        // Return the indented name
        exit(PadStr('', Indentation * 4) + Rec."Job Description");
    end;
}

