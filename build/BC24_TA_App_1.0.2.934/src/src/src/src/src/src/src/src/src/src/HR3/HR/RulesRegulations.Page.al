Page 50542 "Rules & Regulations"
{
    PageType = Worksheet;
    SourceTable = "Rules & Regulations";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(RulesRegulations; Rec."Rules & Regulations")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Rules & Regulations field.';
                }
                field(Attachement; Rec.Attachement)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Attachement field.';
                }
                field(Remarks; Rec.Remarks)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Remarks field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Attachment)
            {
                Caption = '&Attachment';
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    ShortCutKey = 'Return';
                    ToolTip = 'Executes the Open action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then
                            InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    ToolTip = 'Executes the Create action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec."Rules & Regulations";
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Copyfrom)
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    ToolTip = 'Executes the Copy &from action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec."Rules & Regulations";
                            InteractTemplLanguage.Insert;
                            Commit;
                        end;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = Basic;
                    Caption = 'Import';
                    Ellipsis = true;
                    ToolTip = 'Executes the Import action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.Init;
                            InteractTemplLanguage."Interaction Template Code" := Rec.Code;
                            InteractTemplLanguage."Language Code" := Rec."Language Code (Default)";
                            InteractTemplLanguage.Description := Rec."Rules & Regulations";
                            InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                        Rec.Attachement := Rec.Attachement::Yes;
                        Rec.Modify;
                    end;
                }
                action(Export)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    ToolTip = 'Executes the E&xport action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then
                            InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    ToolTip = 'Executes the Remove action.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Rec.Code, Rec."Language Code (Default)") then begin
                            InteractTemplLanguage.RemoveAttachment(true);
                            Rec.Attachement := Rec.Attachement::No;
                            Rec.Modify;
                        end;
                    end;
                }
            }
        }
    }
}

