register_command(speedforceteleport, 

    array(
    
        description: 'Power',
        
        permission: 'ch.alias.speedforceteleport',
        
        noPermMsg: 'Sorry you don\'t have permission to use this command.',
        
        tabcompleter: closure(@alias, @sender, @args) {
            try{
                if(array_size(@args) == 0) {
                    return(all_players());
                }
                @search = @args[array_size(@args) - 1];
                    return(array_filter(all_players(), closure(@index, @player) {
                    return(equals_ic(@search, substr(@player, 0, length(@search))));
                }));
            } catch (RangeException @ErrorInfo) {
                # Ignore
            }
        },
    
        executor: closure(@alias, @sender, @args) {
        
            if (array_size(@args) != 1) {
            
                msg(''.color(RED).color(BOLD).'Improper Usage!');
                msg(''.color(RED).'Usage: /speedforceteleport <player>');
                die(); # No need to go further					
            
            }
            
            @plr = player()
            @vic = @args[0]

            @ploc = ploc()
            @vicLoc = ploc(@vic)
            
            if(@ploc['world'] != @vicLoc['world']){
                die("Sorry, you have to be in the same world as your victim!")
            }
            if(@plr == @vic){
                die("Sorry, you cannot use this on yourself! Use /warp speedforce instead")
            }

            @x1 = @ploc['x']
            @y1 = @ploc['y']
            @z1 = @ploc['z']

            @x2 = @vicLoc['x']
            @y2 = @vicLoc['y']
            @z2 = @vicLoc['z']

            @x3 = pow(@x1 - @x2, 2)
            @y3 = pow(@y1 - @y2, 2)
            @z3 = pow(@z1 - @z2, 2)

            @final = @x3 + @y3 + @z3

            @distance = sqrt(@final)
           
            if(@distance > 2){
                tmsg(@plr, "Make sure you are close enough to grab your victim!")
                die()
            }

            runas(~console, "/warp speedforce " . @vic)
            runas(~console, "/warp speedforce " . @plr)
            tmsg(@vic, @plr . " has brought you into the speedforce!")
            tmsg(@plr, "You brought " . @vic . "  you into the speedforce!")


            @asdf = bind(player_command,null,array('player': @vic),@e,@vic){
                cancel()
                tmsg(@vic,color(RED).'Sorry, you temporarily cannot use commands.')
            }
            set_timeout(30000,closure(
                unbind(@asdf)
                tmsg(@vic,color(RED).'You can use commands again!')
            ))
                include('/home/minecraft/server/plugins/CommandHelper/includes/getHeroClass.ms')
                @vicclass = _getheroclass(@vic)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@vicclass.'.yml')
                    @hero = yml_decode(@contents)
                    @vicHero = @hero
                }catch(Exception @e){
                    @vicHero = array()
                    @vicHero['name'] = @plr
                }
                @plrclass = _getheroclass(@plr)
                try{
                    @contents = read('/home/minecraft/server/plugins/CommandHelper/LocalPackages/commands/chars/'.@plrclass.'.yml')
                    @hero = yml_decode(@contents)
                }catch(Exception @e){
                    @hero = array()
                    @hero['name'] = @plr
                }
                @plrHero = @hero
                set_timeout(3000,closure(
                    broadcast(color(RED).color(ITALIC).'Whoosh'.color(YELLOW).color(BOLD).'! '.@plrHero['name'].color(YELLOW).color(BOLD).' has brought '.color(WHITE).@vicHero['name'].color(YELLOW).color(BOLD).' Into'.color(DARK_RED).color(BOLD).' Th'.color(YELLOW).color(BOLD).'e'.color(DARK_RED).color(BOLD).' Sp'.color(YELLOW).color(BOLD).'ee'.color(DARK_RED).color(BOLD).'df'.color(YELLOW).color(BOLD).'o'.color(DARK_RED).color(BOLD).'r'.color(YELLOW).color(BOLD).'c'.color(DARK_RED).color(BOLD).'e'.color(YELLOW).color(BOLD).'!');
                ))
        }
    )
)
