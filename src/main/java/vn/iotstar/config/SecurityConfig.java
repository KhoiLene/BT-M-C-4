package vn.iotstar.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            // Disable CSRF for REST API calls (PUT, DELETE from AJAX)
            .csrf(csrf -> csrf
                .ignoringRequestMatchers("/api/**")
            )
            // Allow all requests (authentication is still required via form login)
            .authorizeHttpRequests(auth -> auth
                .anyRequest().authenticated()
            )
            // Use default form login
            .formLogin(form -> form
                .defaultSuccessUrl("/category/manage", true)
                .permitAll()
            )
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            );
        return http.build();
    }
}

