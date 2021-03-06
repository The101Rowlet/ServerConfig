register_command(entomb, 

    array(
    
        description: 'Entomb a player',
        
        permission: 'ch.alias.entomb',
        
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
                msg(''.color(RED).'Usage: /entomb <player>');
                die(); # No need to go further					
            
            }
            
            assign(@cooldown, 5)
            assign(@lastshot, import('lastentomb'))

            if(@lastshot + @cooldown > time() / 1000,
                die("5 seconds between /entomb")
            )
            export('lastentomb', time() / 1000)
            
            @attacker = player()
            @victim = @args[0]
            
            
            @vicLoc = ploc(@victim)
            @vicLoc['y'] += 1
            @vicLoc['x'] = integer(@vicLoc['x']) + 0.5
            @vicLoc['z'] = integer(@vicLoc['z']) + 0.5
            set_ploc(@victim,@vicLoc)
            
            assign(@pointer, @vicLoc)
            
            @originalBlocks = array()
            
            @xStart = @pointer['x'] - 1
            @yStart = @pointer['y']
            @zStart = @pointer['z'] - 1
            
            @counter = 0
            
            for(@y = @yStart, @y < @yStart + 5, @y++){
                @pointer['y'] = @y
                for(@x = @xStart, @x < @xStart + 3, @x++){
                    @pointer['x'] = @x
                    for(@z = @zStart, @z < @zStart + 3, @z++){
                        @pointer['z'] = @z
                        
                        array_push(@originalBlocks,get_block_at(@pointer))
                        if(@counter != 22){
                            set_block_at(@pointer,"95:3")
                        }
                        
                        @counter++
                        if(@counter > 200){
                            die()
                        }
                    }
                }
            }
            
            broadcast(@victim "has been entombed by" @attacker)
            
            assign(@pointer, @vicLoc)
            set_timeout(5000, closure(
                @xStart = @pointer['x'] - 2
                @yStart = @pointer['y'] - 4
                @zStart = @pointer['z'] - 2
                @counter = 0
                for(@y = @yStart, @y < @yStart + 5, @y++){
                    @pointer['y'] = @y
                    for(@x = @xStart, @x < @xStart + 3, @x++){
                        @pointer['x'] = @x
                        for(@z = @zStart, @z < @zStart + 3, @z++){
                            @pointer['z'] = @z
                            set_block_at(@pointer,@originalBlocks[@counter])
                            
                            @counter++
                            if(@counter > 100){
                                die()
                            }
                        }
                    }   
                }
            ))
                
        }
    )
)

