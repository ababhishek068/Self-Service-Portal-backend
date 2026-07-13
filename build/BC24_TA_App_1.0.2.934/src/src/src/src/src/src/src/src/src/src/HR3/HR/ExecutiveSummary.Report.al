Report 50240 "Executive Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ExecutiveSummary.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem("Dimension Value"; "Dimension Value")
        {
            DataItemTableView = where("Dimension Code" = filter('DEPARTMENT'));
            column(ReportForNavId_1; 1) { }
            column(Division_DimensionValue; "Dimension Value".Division) { }
            column(Code_DimensionValue; "Dimension Value".Code) { }
            column(Name_DimensionValue; "Dimension Value".Name) { }
            column(Count1; Count1) { }
            column(Count2; count2) { }
            column(Count3; Count3) { }
            column(Year1; Year1) { }
            column(Year2; Year2) { }
            column(Year3; Year3) { }
            column(divName; divName) { }

            trigger OnAfterGetRecord()
            begin
                Count1 := 0;
                count2 := 0;
                Count3 := 0;
                divName := '';

                dimval.Reset;
                dimval.SetRange(dimval.Code, "Dimension Value".Division);
                if dimval.Find('-') then divName := dimval.Name;

                //-------------------------------------------------------------------------
                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '..%2', 0D, Dmy2date(31, 12, Year1));
                objEmp.SetRange(objEmp.Status, objEmp.Status::Active);
                // objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        Count1 := Count1 + 1;
                    until objEmp.Next = 0;

                //010115..311215 disabled
                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '..%2', Dmy2date(1, 1, Year1), Dmy2date(31, 12, Year1));
                objEmp.SetFilter(objEmp.Status, '<>%1', objEmp.Status::Active);
                // objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        Count1 := Count1 + 1;
                    until objEmp.Next = 0;


                //-------------------

                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '..%2', 0D, Dmy2date(31, 12, Year2));
                objEmp.SetRange(objEmp.Status, objEmp.Status::Active);
                // objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        count2 := count2 + 1;
                    until objEmp.Next = 0;

                //010115..311215 disabled
                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '%1..%2', Dmy2date(1, 1, Year2), Dmy2date(31, 12, Year2));
                objEmp.SetFilter(objEmp.Status, '<>%1', objEmp.Status::Active);
                // objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        count2 := count2 + 1;
                    until objEmp.Next = 0;


                //---------------------

                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '..%2', 0D, Dmy2date(31, 12, Year3));
                objEmp.SetRange(objEmp.Status, objEmp.Status::Active);
                //objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        Count3 := Count3 + 1;
                    until objEmp.Next = 0;

                //010115..311215 disabled
                objEmp.Reset;
                objEmp.SetRange(objEmp."Department Code", "Dimension Value".Code);
                objEmp.SetFilter(objEmp."Date Of Joining the Company", '%1..%2', Dmy2date(1, 1, Year3), Dmy2date(31, 12, Year3));
                objEmp.SetFilter(objEmp.Status, '<>%1', objEmp.Status::Active);
                // objEmp.SetRange(objEmp."Part Time", false);
                if objEmp.Find('-') then
                    repeat
                        Count3 := Count3 + 1;
                    until objEmp.Next = 0;
            end;

            trigger OnPreDataItem()
            begin
                /*Year1:=DATE2DMY("First Period",3);
                Year2:=DATE2DMY("Second Period",3);
                Year3:=DATE2DMY("Third Period",3);
                 */

            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("First Period"; Year1)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year1 field.';
                }
                field("Second Period"; Year2)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year2 field.';
                }
                field("Third Period"; Year3)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Year3 field.';
                }
            }
        }

        actions { }
    }

    labels { }

    var
        objEmp: Record "HR-Employee";
        Count1: Integer;
        count2: Integer;
        Count3: Integer;
        Year1: Integer;
        Year2: Integer;
        Year3: Integer;
        dimval: Record "Dimension Value";
        divName: Text;
}

