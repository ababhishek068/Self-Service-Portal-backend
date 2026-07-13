namespace ABH_UAT.ABH_UAT;

page 51519 "Probation Header"
{
    ApplicationArea = All;
    Caption = 'Performance evaluation form for probationers';
    PageType = Card;
    SourceTable = "Probation Header";  
    
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                
                field("Probation Code"; Rec."Probation Code")
                {
                    ToolTip = 'Specifies the value of the Probation Code field.', Comment = '%';
                }
                field("Employee No"; Rec."Employee No")
                {
                    ToolTip = 'Specifies the value of the Employee No field.', Comment = '%';
                }
                field("Employee Name"; Rec."Employee Name")
                {
                    ToolTip = 'Specifies the value of the Employee Name field.', Comment = '%';
                }
                field("Employment Date"; Rec."Employment Date")
                {
                    ToolTip = 'Specifies the value of the Employment Date field.', Comment = '%';
                }
                field("Job ID"; Rec."Job ID")
                {
                    ToolTip = 'Specifies the value of the Job ID field.', Comment = '%';
                }
                field("Job Title"; Rec."Job Title")
                {
                    ToolTip = 'Specifies the value of the Job Title field.', Comment = '%';
                }
                field(Manager; Rec.Manager)
                {
                    ToolTip = 'Specifies the value of the Manager field.', Comment = '%';
                }
                field("Manager's Name"; Rec."Manager's Name")
                {
                    ToolTip = 'Specifies the value of the Manager''s Name field.', Comment = '%';
                }
                field("Requestor ID"; Rec."Requestor ID")
                {
                    ToolTip = 'Specifies the value of the Requestor ID field.', Comment = '%';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 2 Code"; Rec."Global Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.', Comment = '%';
                }
                field("Global Dimension 3 Code"; Rec."Global Dimension 3 Code")
                {
                    ToolTip = 'Specifies the value of the Global Dimension 3 Code field.', Comment = '%';
                }
                field("Date"; Rec."Date")
                {
                    ToolTip = 'Specifies the value of the Date field.', Comment = '%';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.', Comment = '%';
                }
                field("Activity Brief"; Rec."Activity Brief")
                {
                    ToolTip = 'Specifies the value of the Activity Brief field.', Comment = '%';
                }
                field("Weak Points"; Rec."Weak Points")
                {
                    ToolTip = 'Specifies the value of the Weak Points field.', Comment = '%';
                }
                field("Employ Permanently?"; Rec."Employ Permanently?")
                {
                    ToolTip = 'Specifies the value of the Employ Permanently? field.', Comment = '%';
                }
                field(Reason; Rec.Reason)
                {
                    ToolTip = 'Specifies the value of the Reason field.', Comment = '%';
                }
                field("HR Comments"; Rec."HR Comments")
                {
                    ToolTip = 'Specifies the value of the HR Comments field.', Comment = '%';
                }
                field("Average Score"; Rec."Average Score")
                {
                    Editable=false;
                    ToolTip = 'Specifies the value of the Average Score field.', Comment = '%';
                }
                field(Closed; Rec.Closed)
                {
                    ToolTip = 'Specifies the value of the Closed field.', Comment = '%';
                }
                field("Closed By"; Rec."Closed By")
                {
                    ToolTip = 'Specifies the value of the Closed By field.', Comment = '%';
                }
                field("Closed Date"; Rec."Closed Date")
                {
                    ToolTip = 'Specifies the value of the Closed Date field.', Comment = '%';
                }
            }
            part(ratingfactor;"Probation lines")
            {
                SubPageLink="probation code"=field("Probation Code"),"Employee Code"=field("Employee No"),"Job Id"=field("Job ID");
            }
        }
    }

    actions
    {
        area(Processing){
        action(loadlines)
        {
            ApplicationArea = All;
            Caption = 'Load rating factors'; 
            Image = Image;
        
            trigger OnAction()
            var
            checklistno: Integer;
            begin
                TestField("Job ID");
                TestField("Probation Code");
                TestField("Employee No");
                checklistno:=0;
                probationratinlines.Reset();
                probationratinlines.SetRange(probationratinlines."Employee Code","Employee No");
                probationratinlines.SetRange(probationratinlines."probation code","Probation Code");
                probationratinlines.SetRange(probationratinlines."Job Id","Job ID");
                if probationratinlines.Find('-') then begin
                    repeat
                    checklistno:=checklistno+1;

                    until probationratinlines.Next=0;
                    error('Aready existing');

                end else if not probationratinlines.Find() then begin
                    probationchecklist.Reset();
                    probationchecklist.SetRange(probationchecklist."Active?",true);
                    if probationchecklist.Find('-') then begin
                        repeat
                        probationratinlines.Init;
                        probationratinlines."Employee Code":="Employee No";
                        probationratinlines."Job Id":="Job ID";
                        probationratinlines."probation code":="Probation Code";
                        probationratinlines."Rate Code":=probationchecklist.Code;
                        probationratinlines."Rate Factor":=probationchecklist."Rating Factor";
                        probationratinlines.Insert;

                        until probationchecklist.Next=0;
                        Message('Loaded successfully');
                    end;
                end;
                
            end;
        }
    }
    area(Reporting)
    {
        action(printreport)
        {
            ApplicationArea = All;
            Caption = 'Probation report';
            Image = Image;
        
            trigger OnAction()
            var
            probationreport: Report "Probation Report";
            probationratinlines:Record "Probation Lines";

            begin
                probationratinlines.Reset();
                probationratinlines.SetRange(probationratinlines."Job Id","Job ID");
                probationratinlines.SetRange(probationratinlines."probation code","Probation Code");
                probationratinlines.SetRange(probationratinlines."Employee Code","Employee No");
                if probationratinlines.FindFirst() then begin
                    probationreport.SetTableView(probationratinlines);
                    probationreport.Run();                    
                    
                end;    

            end;
        }
    }
    }

    var
    probationratinlines: Record "Probation Lines";
    probationchecklist: Record "Probation Rating Factors";
}

