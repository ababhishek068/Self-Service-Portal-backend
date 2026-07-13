page 51470 EmployeeOrgChart
{
    PageType = List;
    ApplicationArea = All;
    caption='Simple Org Structure';
    UsageCategory = Lists;
    SourceTable = "hr jobs";
    SourceTableView = sorting("job id");
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(FullName; FullName)
                {
                    ApplicationArea = All;
                    // This field needs to be a function that builds the indented name
                }
                field(Title; "job id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    
    var
        CurrentIndentation: Integer;
        
    trigger OnAfterGetRecord()
    begin
        CurrentIndentation := 0;
        Rec.CalcFields("Position Reporting To");
        
        // This is a simplified approach. A more robust solution would require
        // a function to recursively find the manager and determine indentation.
        if Rec."Position Reporting To" <> '' then
        begin
            CurrentIndentation := 1;
        end;
    end;
    
    local procedure FullName() FullName: Text
    begin
        // This is a placeholder for the logic to display an indented name.
        // A more advanced approach would use a treeview or a custom control.
        if CurrentIndentation > 0 then
        begin
            FullName := PadStr('', CurrentIndentation * 4) + Rec."Job Description";
        end
        else
        begin
            FullName := Rec."Job Description";
        end;
    end;
}
