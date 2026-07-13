XmlPort 50005 "Units/Subject"
{
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Temp; "Units/Subjects")
            {
                AutoUpdate = true;
                XmlName = 'Units';
                fieldelement(a11; Temp."Programme Code")
                {
                    MinOccurs = Zero;
                }
                fieldelement(a1; Temp.Code)
                {
                    MinOccurs = Zero;
                }
                fieldelement(a2; Temp.Desription)
                {
                    MinOccurs = Zero;
                }
                fieldelement(a3; Temp."No. Units")
                {
                    MinOccurs = Zero;
                }
                fieldelement(a4; Temp."Unit Category")
                {
                    MinOccurs = Zero;
                }
                fieldelement(a5; Temp.Concentration)
                {
                    MinOccurs = Zero;
                }
            }
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }
}

